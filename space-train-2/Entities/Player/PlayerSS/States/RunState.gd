extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var attack1State: State
@export var attack2State: State
@export var attack3State: State
@export var shootState: State

func enter() -> void:
	var hitbox = parent.find_child("PlayerHitbox")
	hitbox.can_hurt = true
	parent.sword.monitoring = false
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jumpState
	if Input.is_action_just_pressed("dash") and !parent.usedDash:
		return dashState
	if(Input.is_action_just_pressed("attack_melee")):
		if parent.queuedAttack == 1:
			return attack1State
		elif parent.queuedAttack == 2:
			return attack2State
		else:
			return attack3State
	if Input.is_action_just_pressed("fire_projectile"):
		return shootState
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
	parent.move_and_slide()
	
	if !(parent.velocity.x > 1 || parent.velocity.x < -1):
		#need this check to stop player from running into wall (it looks weird)
		if parent.is_on_wall() and direction:
			animations.play("Idle")
		else:
			return idleState
		
	if !parent.is_on_floor():
		parent.fallFromPlatform = true
		return fallState
		
	#flip sprite accordingly to player's input
	if(parent.velocity.x < 0):
		parent.lbp = "l"
	elif(parent.velocity.x > 0):
		parent.lbp = "r"
		
	if(parent.lbp == "l"):
		parent.sword.position = Vector2(-17.5,-10)
		parent.bullets.position = Vector2(-0.5,-13.5)
		animations.flip_h = true
		#parent.hitbox.position.x = -5
	else:
		#parent.scale = Vector2(2,-2)
		parent.sword.position = Vector2(17.5,-10)
		parent.bullets.position = Vector2(0.5,-13.5)
		animations.flip_h = false
		#parent.hitbox.position.x = 0
		
	return null
