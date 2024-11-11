extends CharacterBody2D

class_name SnailMonster

@export var health = 20
@export var speed = 60
@export var attack = 5

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var hit_state : State2

@export var starting_move_direction : Vector2 = Vector2.LEFT
var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)

@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	animation_tree.active = true
	direction = starting_move_direction

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Control wheter to move or not to move
	if direction && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, speed)
	 
	move_and_slide()

func _process(delta: float) -> void:
	if ray_cast_2d_right.is_colliding():
		direction = Vector2.LEFT
		sprite_2d.flip_h = false
	if ray_cast_2d_left.is_colliding():
		direction = Vector2.RIGHT
		sprite_2d.flip_h = true
	emit_signal("facing_direction_changed", sprite_2d.flip_h)
