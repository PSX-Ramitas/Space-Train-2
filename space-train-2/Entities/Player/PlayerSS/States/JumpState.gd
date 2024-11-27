extends State

@export var idleState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var attack1State: State
@export var attack2State: State
@export var attack3State: State
@export var shootState: State
@export var castState: State

func enter() -> void:
	var hitbox = parent.find_child("PlayerHitbox")
	hitbox.can_hurt = true
	var sfx = parent.find_child("JumpSound")
	parent.sword.monitoring = false
	super() #call the enter function of the class we inherit from
	parent.fallFromPlatform = false
	sfx.play()
	parent.velocity.y = jumpVelocity

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("dash") and !parent.usedDash:
		return dashState
	if Input.is_action_just_pressed("attack_melee") and parent.usedAirAttack == false:
		if parent.queuedAttack == 1:
			return attack1State
		elif parent.queuedAttack == 2:
			return attack2State
		else:
			return attack3State
	if Input.is_action_just_pressed("fire_projectile"):
		return shootState
	if Input.is_action_just_pressed("cast_spell"):
		return castState
	return null

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return dieState
	var direction = Input.get_axis("left", "right")
	if direction:
		parent.velocity.x = direction * moveSpeed
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, 100)
		
	parent.velocity.y += gravity * delta
	if Input.is_action_just_released('jump'):
		parent.velocity.y *= 0.625
	parent.move_and_slide()
	
	#flip sprite accordingly to player's input
	if(parent.velocity.x < 0):
		parent.lbp = "l"
	elif(parent.velocity.x > 0):
		parent.lbp = "r"
	if(parent.lbp == "l"):
		animations.flip_h = true
	else:
		animations.flip_h = false
	if(parent.lbp == "l"):
		parent.sword.position = Vector2(-17.5,-10)
		animations.flip_h = true
		#parent.hitbox.position.x = -5
	else:
		#parent.scale = Vector2(2,-2)
		parent.sword.position = Vector2(17.5,-10)
		animations.flip_h = false
		#parent.hitbox.position.x = 0
	if not parent.is_on_floor() and parent.velocity.y > 0:
		return fallState
	if parent.is_on_floor():
		return idleState
	return null
