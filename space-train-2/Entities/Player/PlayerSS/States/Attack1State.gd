extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var attack2State: State
@export var shootState: State
@export var castState: State
var nextState: State
var attackFinished: bool

func enter() -> void:
	var hb = parent.find_child("PlayerHitbox")
	hb.dash_used = false
	var sfx = parent.find_child("Sword1")
	sfx.play()
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
		
	parent.queuedAttack = 2
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
			nextState = attack2State
			return nextState
		elif Input.is_action_just_pressed("jump"):
			nextState = jumpState
			return nextState
		elif Input.is_action_just_pressed("dash"):
			nextState = dashState
			return nextState
		elif Input.is_action_just_pressed("cast_spell"):
			nextState = dashState
			return castState
		else:
			nextState = idleState
			return nextState
	return null


@rpc("any_peer", "call_local")
func FinishedAttack():
	attackFinished = true
