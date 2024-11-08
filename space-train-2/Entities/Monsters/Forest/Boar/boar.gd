extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var speed = 60
var direction : Vector2
var health = 40
@export var hit_state : State2


func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = starting_move_direction
	# Control wheter to move or not to move
	if direction && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, speed)
	 
	move_and_slide()
