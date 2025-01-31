extends Entity
class_name droidEnemy

const gravity =900 #custom gravity
var windupTimer = .3
var direction = Vector2.RIGHT
var player 
@onready var attackArea = $AttackArea
@onready var animations = $AnimatedSprite2D
@onready var attackSound: AudioStreamPlayer = $Sounds/Attack
@onready var chargeSound1: AudioStreamPlayer = $Sounds/Charge
@onready var chargeSound2: AudioStreamPlayer = $Sounds/Ready
@onready var death_sound: AudioStreamPlayer = $Sounds/DeathSound

var prevHealth = health
var type: String = "electric"

enum State {
	Roam,
	Chase,
	Attack,
	Hurt,
	Death,
}
var currentState = State.Roam

func get_state():
	return currentState

func _ready() -> void:
	currentState = State.Roam

func get_health():
	return health

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
	attackArea.monitoring = false;
	animations.play("walking")
	velocity += direction * movespeed * delta
	pass
	
func ChaseState():
	attackArea.monitoring = false;
	animations.play("walking")
	var dir_to_player = position.direction_to(player.position) * movespeed
	velocity.x = dir_to_player.x
	direction.x = abs(velocity.x) / velocity.x # flip direction when turning

func AttackState(delta):
	animations.play("attack")
	if animations.frame == 0:
		if chargeSound1.playing == true:
			chargeSound1.stop()
		if chargeSound2.playing == true:
			chargeSound2.stop()
	if animations.frame == 1:
		attackSound.play()
	windupTimer -= delta
	if windupTimer <= 0:
		attackArea.monitoring = true;
	pass
func HurtState():
	attackArea.monitoring = false;
	animations.play("hurt")
	pass
func DeathState(delta):
	animations.play("death")
	attackArea.monitoring = false;
	pass

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
		chargeSound1.play()
		player = area.get_parent()
		currentState = State.Chase
	pass # Replace with function body.

func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		if chargeSound1.playing == true:
			chargeSound1.stop()
		if chargeSound2.playing == true:
			chargeSound2.stop()
		currentState = State.Roam

func _on_attack_range_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		currentState = State.Attack

func _on_animated_sprite_2d_animation_finished() -> void:
	match currentState:
		State.Attack:
			windupTimer = .5
			currentState = State.Roam
		State.Hurt:
			currentState = State.Roam
		State.Death:
			queue_free()


func _on_charge_finished() -> void:
	chargeSound2.play()
