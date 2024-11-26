extends CharacterBody2D

enum GUIDE_STATE { IDLE, WALK, TALK}

@export var speed = 100
@export var idle_time : float = 5
@export var walk_time : float = 2

@onready var animation_tree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var dialogue: Label = $Dialogue
var ballon_scene = preload("res://Main_Areas/Spaceship/NPC/Dialogue/game_dialogue_balloon.tscn")
var ballon : BaseGameDialogueBalloon
@onready var dialogue_timer: Timer = $InteractionArea/DialogueTimer
@onready var interactable_label_component: Control = $InteractableLabelComponent

var NPC_dialogue = false
var move_direction : Vector2 = Vector2.ZERO
var current_state : GUIDE_STATE = GUIDE_STATE.IDLE

var interacted: bool
		
func _ready() -> void:
	interacted = false
	interactable_label_component.hide()
	dialogue.visible = false
	update_animation_parameters(move_direction)
	pick_new_state()

func _physics_process(delta):
	if(current_state == GUIDE_STATE.WALK):
		velocity = move_direction * speed
		move_and_slide()

func select_new_direction():
	move_direction = Vector2(randi_range(0,0),randi_range(0,0))
	update_animation_parameters(move_direction)
	#if(move_direction.x < 0):
		#sprite.flip_h = false
	#elif(move_direction.x > 0):
		#sprite.flip_h = true

func update_animation_parameters(move_input):
	if(move_input != Vector2.ZERO):
		animation_tree.set('parameters/facing/blend_position', move_input)

func pick_new_state():
	if(current_state == GUIDE_STATE.IDLE):
		animation_state_machine.travel('facing')
		current_state = GUIDE_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	elif(current_state == GUIDE_STATE.WALK):
		animation_state_machine.travel('facing')
		current_state = GUIDE_STATE.IDLE
		timer.start(idle_time)

func _on_timer_timeout() -> void:
	pick_new_state()

func _process(delta: float) -> void:
	if NPC_dialogue and !interacted:
		if Input.is_action_just_pressed("conversation_start"):
			ballon = ballon_scene.instantiate()
			get_tree().current_scene.add_child(ballon)
			ballon.start(load("res://Main_Areas/Spaceship/NPC/Dialogue/Conversations/lost.dialogue"), "start")
			interacted = true
			#dialogue.text = "Do you want to explore new planets?"
		

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if !interacted:
		interactable_label_component.show()
	current_state = GUIDE_STATE.IDLE
	timer.stop()
	dialogue.visible = true
	if !interacted:
		dialogue.text = "Hello"
	else:
		dialogue.text = "Hello Again."
	NPC_dialogue = true
	

func _on_interaction_area_body_exited(body: Node2D) -> void:
	interactable_label_component.hide()
	if interacted:
		dialogue.text = "Be seeing you back at the ship."
	else:
		dialogue.text = "Oh, ok."
	NPC_dialogue = false
	timer.start()
	dialogue_timer.start()
	

func _on_dialogue_timer_timeout() -> void:
	dialogue.visible = false
