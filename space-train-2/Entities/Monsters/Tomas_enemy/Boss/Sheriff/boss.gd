extends Entity
class_name Boss


@onready var bossInstance = get_node(".")

@onready var projectile = load("res://Entities/Monsters/Tomas_enemy/Bot Wheel/enemy_projectile.tscn")
var can_shoot = false
var can_attack = false
var dead = false
const gravity = 900 #custom gravity
var windupTimer = .3
var direction = Vector2.RIGHT
var player 
var playerInChaseRange = false
var playerInAttackRange = false
var fromState
var boss_mechanics 
@onready var Boss_Sword_Area = get_node("BossSwordArea")
@onready var playerSS = get_node("../PlayerSS")
@onready var attackArea = $CloseAttackArea
@onready var animations = $AnimatedSprite2D
var attacks = ["attack", "attack_3", "attack_2"]

var prevHealth = health
enum State {Roam,Chase,Attack,Hurt,Death,}
var currentState = State.Roam

@export var boss_facing_shape : BossFacingCollisionShape2D
@export var boss_hitbox_facing_shape : BossHitCollisionShape2D
signal boss_facing_direction_changed(facing_right : bool)
	
func get_health(): 
	return health
func get_state():
	return currentState

func _ready() -> void:
	print("ready() <- ", fromState)
	currentState = State.Roam
	boss_mechanics = $Boss_Mechanics
	connect("boss_facing_direction_changed", _on_boss_facing_direction_changed)
	fromState = "_ready"

func _sprite_orientation(direction):
	print("SpriteOrientation <- ", fromState, "\n")
	var left_offset =95
	var right_offset=-8
	var dir_to_player = position.direction_to(playerSS.position) * movespeed
	velocity.x = dir_to_player.x
	direction.x = abs(velocity.x) / velocity.x # flip direction when turning
	if direction.x < 0 :
		animations.flip_h = true
	#	print("$bossSwordArea.position.x (true), ", $BossSwordArea.position.x)
		$BossSwordArea.position.x = -abs(left_offset)
	elif direction.x==0:
		animations.flip_h = true
	#	print("$bossSwordArea.position.x (true), ", $BossSwordArea.position.x)
		$BossSwordArea.position.x = -abs(left_offset)
	else:
		animations.flip_h = false
		#print("$bossSwordArea.position.x (false), ", $BossSwordArea.position.x)
		$BossSwordArea.position.x = abs(right_offset)
	emit_signal("boss_facing_direction_changed", !$AnimatedSprite2D.flip_h)
#	pass
	fromState = "SpriteOrientation"

func _process(delta):
	print("_process <- ", fromState, "\n")
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x =0
	if health < prevHealth:
		currentState = State.Hurt
	prevHealth = health
	if health <= 0:
		currentState = State.Death
	match currentState:
		State.Roam:
			RoamState(delta)
		State.Chase:
			ChaseState()
		State.Attack:
			AttackState(delta)
		State.Hurt:
			HurtState()
		State.Death:
			DeathState(delta)
	move_and_slide()
	fromState= "_process"

func _physics_process(delta):
	print("_physics_proces <- ", fromState, "\n")
	var knockback = boss_mechanics.process_knockback(delta)
	if knockback != Vector2.ZERO:
		move_and_slide()
	else:
		pass
	fromState = "_physics_process"
	
func RoamState(delta):
	print("RoamState <- ", fromState, "\n")
	animations.play("walk")
	velocity += direction * movespeed * delta
	_sprite_orientation(direction)
	fromState="RoamState"

func ChaseState():
	print("ChaseState <- ", fromState, "\n")
	animations.play("chase")
	_sprite_orientation(direction)
	fromState= "ChaseState"
	#shoot()

func AttackState(delta):
	print("AttackState <- ", fromState, "\n")
	if can_attack:
		_sprite_orientation(direction)
		animations.play("attack")
		windupTimer -= delta
		if windupTimer <= 0:
			if attackArea: 
				attackArea.monitoring = true
		else:
			pass 
			#print("attackArea not assigned")
		$Attack_Timer.start()
	fromState= "AttackState"		
		

func HurtState():
	print("hurtState <- ", fromState, "\n")
	can_attack=false
	#print ("player position var is : ", player_position)
	var knockback_direction = global_position - playerSS.global_position
	#print("knockback direction is : ", knockback_direction)
	boss_mechanics.apply_knockback(knockback_direction, 0.3)
	if $AnimatedSprite2D.animation != "hurt":
	#	print("if $AnimatedSprite2D.animation != hurt:")
		animations.play("hurt")
	fromState= "hurtState"

func DeathState(delta):
	print("in DeathState <- ", fromState, "\n")
	dead=true
	animations.play("death")
	queue_free()
	if !dead:
		attackArea.monitoring = false
	fromState="DeathState"

func choose(array):
	array.shuffle()
	return array.front()

func _on_direction_timer_timeout() -> void:
	print("in DirTimerTimeout <- ", fromState, "\n")
	$DirectionTimer.wait_time= choose([1.5,2.0,2.5])
	if currentState == State.Roam:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x=0
	fromState= "DirTimerTimeout"

func _on_animated_sprite_2d_animation_finished() -> void:
		print("in animationFinished <- ", fromState, "\n")
		match currentState:
			State.Attack:
				attackArea.monitoring = false
				windupTimer = .5
				currentState = State.Roam
				if playerInAttackRange:
					_sprite_orientation(direction)
					currentState = State.Attack

					#shoot()
			State.Hurt:
				currentState = State.Chase
				if playerInAttackRange:
					currentState = State.Attack
					#shoot()
			State.Death:
				dead= true
				queue_free()
				"we queued freed chat"

		fromState= "animationFinished"

func _on_attack_timer_timeout() -> void:
	print("attackTimerTimeout, from ", fromState, "\n")
	can_attack =true
	#_sprite_orientation(direction)
	fromState= "attackTimerTimeout"

#player has entered boss' attack radius, boss attacks
func _on_boss_chase_radius_area_entered(area: Area2D) -> void:
	print("bossChaseRadiusEntered <- ", fromState, "\n")
	if area.get_parent() is Player:
		print ("area in boss chase enterred: ", area.name)
		playerInChaseRange= true
		player = area.get_parent()
		#_sprite_orientation(direction)
		currentState = State.Chase
	fromState= "bossChaseRadiusEntered"
func _on_boss_chase_radius_area_exited(area: Area2D) -> void:
	print("on bossChaseRadiusExited, from ",fromState, "\n")
	if area.get_parent() is Player:
	#if area is PlayerHitbox:
			playerInChaseRange = false
			currentState = State.Roam
	fromState= "bossChaseRadiusExited"	

func _on_boss_attack_range_area_entered(area: Area2D) -> void:
	print("in bossAttackRangeEntered <- ",fromState, "\n")
	#if area.get_parent() is Player:
	if area is PlayerHitbox:
		playerInAttackRange= true
		can_attack=true
		#playerInChaseRange = false
		player = area.get_parent()
		_sprite_orientation(direction)
		currentState= State.Attack
	fromState= "bossAttackRangeEntered"	

func _on_boss_attack_range_area_exited(area: Area2D) -> void:
	print("bossAttackRangeExited <- ", fromState, "\n")
	#if area.get_parent() is Player:
	if area is PlayerHitbox:
			playerInAttackRange = false
			can_attack=false
			playerInChaseRange=true
			_sprite_orientation(direction)
			currentState = State.Chase
	fromState = "bossAttackRangeExited"

func _on_boss_facing_direction_changed(facing_right : bool):
	print("in bossFacingDirChanged <-", fromState, "\n")
#	print("on boss dir changed")
	if(facing_right):
		boss_hitbox_facing_shape.position = boss_hitbox_facing_shape.boss_hitbox_facing_right_position
		boss_facing_shape.position = boss_facing_shape.boss_facing_right_position
	else:
		boss_facing_shape.position = boss_facing_shape.boss_facing_left_position
		boss_hitbox_facing_shape.position = boss_hitbox_facing_shape.boss_hitbox_facing_left_position
	fromState = "bossFacingDirChanged"
