extends State

@export var fallState: State
@export var jumpState: State
@export var moveState: State
@export var dashState: State
@export var attack1State: State
@export var attack2State: State
@export var attack3State: State
@export var dieState: State

func enter() -> void:
	if parent.is_on_floor():
		parent.usedAirAttack = false
	super() #call the enter function of the class we inherit from
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("dash") and !parent.usedDash:
		return dashState
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jumpState
	if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('right'):
		return moveState
	if(Input.is_action_just_pressed("attack_melee")):
		if parent.queuedAttack == 1:
			return attack1State
		elif parent.queuedAttack == 2:
			return attack2State
		else:
			return attack3State
	return null

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return dieState
	var direction = Input.get_axis("left", "right")
	if(direction):
		return moveState
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fallState
	return null
