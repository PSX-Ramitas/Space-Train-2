extends Entity
class_name Boss


@onready var bossInstance = get_node(".")

@onready var projectile = load("res://Entities/Monsters/Tomas_enemy/Bot Wheel/enemy_projectile.tscn")
var can_shoot = false
var can_attack = false
var dead = false
const gravity = 900 #custom gravity
var windupTimer = .2
var direction = Vector2.RIGHT
var player 
var playerInChaseRange = false
var playerInAttackRange = false
var boss_mechanics 
@onready var Boss_Sword_Area = get_node("BossSwordArea")
@onready var playerSS = get_node("../PlayerSS")
@onready var BossAttackArea = $BossAttackRange
@onready var BossChaseRadius = $BossChaseRadius
@onready var animations = $AnimatedSprite2D
@onready var PlayerHitBox = $PlayerHitBox
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
	currentState = State.Roam
	boss_mechanics = $Boss_Mechanics
	connect("boss_facing_direction_changed", _on_boss_facing_direction_changed)

func _sprite_orientation(direction):
	var left_offset =95
	var right_offset=-8
	var dir_to_player = position.direction_to(playerSS.position) * movespeed
	velocity.x = dir_to_player.x
	direction.x = abs(velocity.x) / velocity.x # flip direction when turning
	if direction.x < 0 :
		animations.flip_h = true
	#	print("$bossSwordArea.position.x (true), ", $BossSwordArea.position.x)
		$BossSwordArea.position.x = -abs(left_offset)
	else:
		animations.flip_h = false
		#print("$bossSwordArea.position.x (false), ", $BossSwordArea.position.x)
		$BossSwordArea.position.x = abs(right_offset)
	emit_signal("boss_facing_direction_changed", !$AnimatedSprite2D.flip_h)

func _process(delta):
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

func _physics_process(delta):
	var knockback = boss_mechanics.process_knockback(delta)
	if knockback != Vector2.ZERO:
		position += knockback * delta
	else:
		pass
	
func RoamState(delta):
	print("ROAMSTATE")
	can_attack=false
	animations.play("walk")
	velocity += direction * movespeed * delta
	_sprite_orientation(direction)

func ChaseState():
	print("CHASE\n")
	animations.play("chase")
	_sprite_orientation(direction)
	if BossAttackArea: 
			BossAttackArea.monitoring = true
	#shoot()

func AttackState(delta):
	print ("ATTACK")
	if can_attack:
		attacks.shuffle
		_sprite_orientation(direction)
	#	animations.play(attacks[0])
		#windupTimer -= delta
		#if windupTimer <= 0:
			#if BossAttackArea: 
				#BossAttackArea.monitoring = true
		#else:
			#pass 
		can_attack= false
		$Attack_Timer.start()
		

func HurtState():
	print("HURT")
	can_attack=false
	var knockback_direction = global_position - playerSS.global_position
	boss_mechanics.apply_knockback(knockback_direction, 0.1)
	if animations.animation != "hurt":
		animations.play("hurt")

func DeathState(delta):
#	print("in DeathState <- ", fromState, "\n")
	dead=true
	animations.play("death")
	queue_free()
	if !dead:
		BossAttackArea.monitoring = false

func choose(array):
	array.shuffle()
	return array.front()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time= choose([1.5,2.0,2.5])
	if currentState == State.Roam:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x=0

func _on_animated_sprite_2d_animation_finished() -> void:
		match currentState:
			State.Attack:
				if playerInAttackRange:
					_sprite_orientation(direction)
					currentState = State.Attack
				else:
					#BossAttackArea.monitoring = false
					windupTimer = .3
					currentState = State.Chase

					#shoot()
			State.Hurt:
				can_attack=true
				if playerInAttackRange:
					currentState = State.Attack
				else:
					currentState = State.Chase
					#shoot()
			State.Death:
				dead= true
				queue_free()


func _on_attack_timer_timeout() -> void:
	can_attack =true

#player has entered boss' attack radius, boss attacks
func _on_boss_chase_radius_area_entered(area: Area2D) -> void:
	if area.name == "PlayerSwordArea":
		print ("bossChaseRadius enterred by : ", area.name)
		currentState = State.Chase
		playerInChaseRange= true
		player = area.get_parent()
		BossChaseRadius.monitoring=true

func _on_boss_chase_radius_area_exited(area: Area2D) -> void:
	if area.name == "PlayerSwordArea":
			print ("bossChaseRadius exited by : ", area.name)
			currentState = State.Roam
			playerInChaseRange = false
			BossChaseRadius.monitoring=true

func _on_boss_attack_range_area_entered(area: Area2D) -> void:
	BossAttackArea.monitoring=true
	if area is PlayerHitbox:
		print("boss atackk range entered PLAYERHITBOX")
		can_attack=true
		playerInAttackRange= true
		playerInChaseRange = false
		_sprite_orientation(direction)
		currentState= State.Attack
		player = area.get_parent()

func _on_boss_attack_range_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
			can_attack=false
			print("boss attack range exited")
			playerInChaseRange=true
			playerInAttackRange = false
			_sprite_orientation(direction)
			currentState = State.Chase

func _on_boss_facing_direction_changed(facing_right : bool):
	if(facing_right):
		boss_hitbox_facing_shape.position = boss_hitbox_facing_shape.boss_hitbox_facing_right_position
		boss_facing_shape.position = boss_facing_shape.boss_facing_right_position
	else:
		boss_facing_shape.position = boss_facing_shape.boss_facing_left_position
		boss_hitbox_facing_shape.position = boss_hitbox_facing_shape.boss_hitbox_facing_left_position
