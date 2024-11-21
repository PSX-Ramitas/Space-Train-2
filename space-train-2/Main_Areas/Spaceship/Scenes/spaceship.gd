extends Node2D
var teleportable = false

var radius = 200
var omega = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var label: Label = $Label
@onready var interactable_label_component: Control = $InteractableLabelComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_label_component.visible = false
	if LevelManager.worldClear == true:
		LevelManager.worldClear = false
		transition.play_transition("Split")
	elif PlayerData.is_dead == true:
		PlayerData.is_dead = false
		transition.play_transition("FadeIn")
	elif PlayerData.forfeited == true:
		PlayerData.forfeited = false
		transition.play_transition("FadeIn")
	else:
		transition.play_transition("Split")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.offset.x = radius * cos(omega)
	animated_sprite_2d.offset.y = radius * sin(omega)
	if teleportable:
		if Input.is_action_just_pressed("interact"):
			transition.play_transition("FadeOut")


func _on_planet_rotation_timeout() -> void:
	if(omega > 6.28319):
		omega = 0
	omega += 0.005
	
func _on_transition_finished() -> void:
	if teleportable:
		LevelManager.loadLevel()


func _on_teleporter_area_body_entered(body: Node2D) -> void:
	teleportable = true
	label.visible = false
	interactable_label_component.visible = true

func _on_teleporter_area_body_exited(body: Node2D) -> void:
	teleportable = false
	label.visible = false
	interactable_label_component.visible = false


func _on_button_button_down() -> void:
	interactable_label_component.visible = false
	transition.play_transition("FadeOut")
