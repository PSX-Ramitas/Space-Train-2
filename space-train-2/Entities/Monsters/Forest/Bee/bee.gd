extends CharacterBody2D

@export var health = 10
@export var speed = 60
@export var attack = 10
var used_dash = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var hit_state : State2

@export var starting_move_direction : Vector2 = Vector2(-1,1)
var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)

@onready var movement_left: RayCast2D = $MovementLeft
@onready var movement_right: RayCast2D = $MovementRight
@onready var movement_up: RayCast2D = $MovementUp
@onready var movement_down: RayCast2D = $MovementDown

@onready var detection_left: RayCast2D = $DetectionLeft
@onready var detection_bottom_left: RayCast2D = $DetectionBottomLeft
@onready var detection_top_left: RayCast2D = $DetectionTopLeft

@onready var detection_right: RayCast2D = $DetectionRight
@onready var detection_bottom_right: RayCast2D = $DetectionBottomRight
@onready var detection_top_right: RayCast2D = $DetectionTopRight

func _ready() -> void:
	animation_tree.active = true
	direction = starting_move_direction

func get_health():
	return health

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Control wheter to move or not to move
	if direction && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()

func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if movement_right.is_colliding():
		direction.x =  -1
		sprite_2d.flip_h = false
	if movement_left.is_colliding():
		direction.x = 1
		sprite_2d.flip_h = true
	if movement_up.is_colliding():
		direction.y = 1
	if movement_down.is_colliding():
		direction.y = -1
	emit_signal("facing_direction_changed", sprite_2d.flip_h)
