extends Entity
class_name Boss


@onready var bossInstance = get_node(".")

@onready var projectile = load("res://Entities/Monsters/Tomas_enemy/Bot Wheel/enemy_projectile.tscn")
var can_shoot = true
var can_attack = true
var dead = false
const gravity = 900 #custom gravity
var windupTimer = .3
var direction = Vector2.RIGHT
var player 
var playerInChaseRange = false
var playerInAttackRange = false
@onready var attackArea = $CloseAttackArea
@onready var animations = $AnimatedSprite2D
var attacks = ["attack", "attack_3", "attack_2","air_attack"]

var prevHealth = health
enum State {Roam,Chase,Attack,Hurt,Death,}
var currentState = State.Roam


	
func get_health(): 
	return health
func get_state():
	return currentState

func _ready() -> void:
	currentState = State.Roam

func _sprite_orientation(direction):
	if direction.x < 0 :
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func shoot():
	if can_shoot: 
		var gun_offset = Vector2(-45,-28)
		var instance = projectile.instantiate()
		instance.spawnPos= global_position + gun_offset.rotated(global_rotation)
		instance.spawnRot = global_rotation
		bossInstance.add_child(instance)
		if $AnimatedSprite2D.flip_h:
			instance.dir = Vector2.LEFT  
		else:
			instance.dir = Vector2.RIGHT  # Normal direction to the right
		can_shoot=false
		#$Shooting_Timer.start()

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
	
func RoamState(delta):
	#print("roam state")
	animations.play("walk")
	velocity += direction * movespeed * delta
	_sprite_orientation(direction)

func ChaseState():
	#print("chase state")
	animations.play("chase")
	var dir_to_player = position.direction_to(player.position) * movespeed
	velocity.x = dir_to_player.x
	direction.x = abs(velocity.x) / velocity.x # flip direction when turning
	_sprite_orientation(direction)
	#shoot()

func AttackState(delta):
	if can_attack:
		var random_attack = attacks[0]
		attacks.shuffle()
		var dir_to_player = position.direction_to(player.position) * movespeed
		velocity.x = dir_to_player.x
		direction.x = abs(velocity.x) / velocity.x # flip direction when turning
		_sprite_orientation(direction)
		animations.play(random_attack)
		windupTimer -= delta
		if windupTimer <= 0:
			if attackArea: 
				attackArea.monitoring = true
		else:
			pass 
			#print("attackArea not assigned")
		can_attack = false
		$Attack_Timer.start()
		
		

func HurtState():
	#print("hurt state")
	if $AnimatedSprite2D.animation != "hurt":
		animations.play("hurt")

func DeathState(delta):
	#print("we ded state")
	dead=true
	queue_free()
	#animations.play("death")
	if !dead:
		attackArea.monitoring = false


func choose(array):
	array.shuffle()
	return array.front()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time= choose([1.5,2.0,2.5])
	if currentState == State.Roam:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x=0

func _on_animated_sprite_2d_animation_finished() -> void:
		#print ("on animated sprite finished")
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
				currentState = State.Roam
				if playerInAttackRange:
					currentState = State.Attack
					#shoot()
			State.Death:
				dead= true
				queue_free()
				"we queued freed chat"


func _on_attack_timer_timeout() -> void:
	#print("on shooting timer time out")
	can_attack =true
	_sprite_orientation(direction)


#player has entered boss' attack radius, boss attacks
func _on_boss_attack_radius_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerInChaseRange= true
		player = area.get_parent()
		_sprite_orientation(direction)
		currentState = State.Attack


func _on_boss_attack_radius_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
			playerInChaseRange = false
			currentState = State.Roam
