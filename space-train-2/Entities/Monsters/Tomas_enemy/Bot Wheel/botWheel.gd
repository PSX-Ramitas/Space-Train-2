extends Entity
class_name botWheel

@onready var botWheelIns = get_node(".")

@onready var projectile = load("res://Entities/Monsters/Tomas_enemy/Bot Wheel/enemy_projectile.tscn")
var can_shoot = true
var dead = false
const gravity = 900 #custom gravity
var windupTimer = .3
var direction = Vector2.RIGHT
var player 
var playerInChaseRange = false
var playerInAttackRange = false
@onready var attackArea = $AttackArea
@onready var animations = $AnimatedSprite2D

var prevHealth = health
enum State {Roam,Chase,Attack,Hurt,Death,}
var currentState = State.Roam


	
func get_health(): 
	return health


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
		botWheelIns.add_child(instance)
		if $AnimatedSprite2D.flip_h:
			instance.dir = Vector2.LEFT  
		else:
			instance.dir = Vector2.RIGHT  # Normal direction to the right
		can_shoot=false
		$Shooting_Timer.start()

func _process(delta):
	#print ("_process function")
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
	animations.play("move_fx")
	velocity += direction * movespeed * delta
	_sprite_orientation(direction)

func ChaseState():
#	print("chase state")
	animations.play("move_fx")
	var dir_to_player = position.direction_to(player.position) * movespeed
	velocity.x = dir_to_player.x
	direction.x = abs(velocity.x) / velocity.x # flip direction when turning
	_sprite_orientation(direction)
	shoot()

func AttackState(delta):
	#print("attack state")
	_sprite_orientation(direction)
	animations.play("shoot_fx")
	windupTimer -= delta
	if windupTimer <= 0:
		if attackArea: 
			attackArea.monitoring = true
		else: 
			print("attackArea not assigned")

func HurtState():
	#print("hurt state")
	animations.play("hurt")
	

func DeathState(delta):
	#print("we ded state")
	dead=true
	animations.play("death")
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

func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("shooting range entered by player")
		player = area.get_parent()
		playerInChaseRange = true
		currentState = State.Chase
		_sprite_orientation(direction)
	

func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerInChaseRange = false
		currentState = State.Roam
	

func _on_attack_range_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerInAttackRange = true
		currentState = State.Attack
func _on_attack_range_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		playerInAttackRange = false
		currentState = State.Chase

func _on_animated_sprite_2d_animation_finished() -> void:
	match currentState:
		State.Attack:
			attackArea.monitoring = false
			windupTimer = .5
			currentState = State.Roam
			if playerInAttackRange:
				currentState = State.Attack
				shoot()
		State.Hurt:
			currentState = State.Roam
			if playerInAttackRange:
				currentState = State.Attack
				shoot()
		State.Death:
			dead =true
			queue_free()


func _on_shooting_timer_timeout() -> void:
	can_shoot =true
