extends CharacterBody2D

class_name Player2

@export var active = false
@export var layer = get_collision_layer()

@export var maxHealth = 120
@export var health: int = 120
@export var attack: int = 20
@export var speed : float = 300.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var hit_state : State2

var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	if active:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_vector("left", "right", "up", "down")
		# Control wheter to move or not to move
		if direction.x && state_machine.check_if_can_move():
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		 
		move_and_slide()
		update_animation_parameters()
		update_facing_direction()
	if active:
		self.visible = true
		set_collision_layer_value(2, true)
	else:
		self.visible = false
		set_collision_layer_value(2, false)
	
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	emit_signal("facing_direction_changed", !sprite.flip_h)
