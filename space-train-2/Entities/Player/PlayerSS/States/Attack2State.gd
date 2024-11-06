extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var attack3State: State

var nextState: State
var attackFinished: bool

func enter() -> void:
	parent.sword.monitoring = true
	if !parent.is_on_floor():
		parent.usedAirAttack = true
	#kill y movement so that it can not be abused to jump higher
	parent.velocity.y = 0
	#used to move the player forwards a bit
	if(parent.lbp == "l"):
		parent.velocity.x = dashVelocity * 0.2
	else:
		parent.velocity.x = -dashVelocity * 0.2
		
	parent.queuedAttack = 3
	attackFinished = false
	nextState = idleState
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return dieState
	#move player forwards
	parent.velocity.x = move_toward(parent.velocity.x, 0, 50)
	#apply a little bit of gravity
	parent.velocity.y += gravity * delta * .075
	# only one attack while in air:
	if !parent.is_on_floor() and attackFinished:
		nextState = fallState
		return fallState
	parent.move_and_slide()
	if attackFinished == true:
		if Input.is_action_just_pressed("attack_melee"):
			nextState = attack3State
			parent.sword.monitoring = false
			return nextState
		elif Input.is_action_just_pressed("jump"):
			nextState = jumpState
			return nextState
		elif Input.is_action_just_pressed("dash"):
			nextState = dashState
			return nextState
		else:
			nextState = idleState
			return nextState
	return null


@rpc("any_peer", "call_local")
func FinishedAttack():
	attackFinished = true
	parent.sword.monitoring = false
	
