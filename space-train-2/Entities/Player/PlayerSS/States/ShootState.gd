extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var moveState: State
@export var projectile :PackedScene

var nextState: State
var attackFinished: bool
var bulletCounter: int = 0

func enter() -> void:
	var hb = parent.find_child("PlayerHitbox")
	parent.usedGun = true
	hb.dash_used = false
	if bulletCounter < 20:
		var sfx = parent.find_child("BulletSound")
		sfx.play()
		parent.sword.monitoring = false
		#used to move the player forwards a bit
		bulletCounter += 1
		Fire()
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return dieState
	if Input.is_action_just_pressed("dash") and !parent.usedDash:
		return dashState
	if parent.velocity.y != 0:
		return fallState
	if parent.velocity.x != 0 and parent.is_on_floor():
		return moveState
	return idleState

@rpc("any_peer", "call_local")
func Fire():
	var b = projectile.instantiate()
	b.global_position = $"../../ProjectileSpawn".global_position
	if parent.lbp == "l":
		b.velocity = b.SPEED * Vector2(-1,0)
	else:
		b.velocity = b.SPEED * Vector2(1,0)
	get_tree().root.add_child(b)
	await b.tree_exited
	bulletCounter -= 1


@rpc("any_peer", "call_local")
func FinishedAttack():
	attackFinished = true
func _on_animated_sprite_2d_animation_finished() -> void:
	FinishedAttack()
