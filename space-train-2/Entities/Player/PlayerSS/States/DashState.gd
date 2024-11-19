extends State

@export var fallState: State
@export var idleState: State
@export var moveState: State
@export var dieState: State

func enter() -> void:
	var sfx = parent.find_child("DashSound")
	sfx.play()
	parent.sword.monitoring = false
	super() #call the enter function of the class we inherit from
	parent.usedDash = true
	parent.velocity.y = 0;
	if(parent.lbp == "l"):
		parent.velocity.x = dashVelocity
	else:
		parent.velocity.x = -dashVelocity
func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return dieState
	parent.velocity.x = move_toward(parent.velocity.x, 0, 50)
	#apply a little bit of gravity
	parent.velocity.y += gravity * delta * .075
	
	parent.move_and_slide()
	if !(parent.velocity.x > 1.0 || parent.velocity.x < -1.0):
		return fallState
	return null
