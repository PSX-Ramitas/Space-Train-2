extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var projectile :PackedScene

var nextState: State
var attackFinished: bool
var bulletCounter: int
func enter() -> void:
	if bulletCounter < 5:
		var sfx = parent.find_child("BulletSound")
		sfx.play()
		parent.sword.monitoring = false
		#used to move the player forwards a bit
		if(parent.lbp == "l"):
			parent.velocity.x = dashVelocity * 0.2
		else:
			parent.velocity.x = -dashVelocity * 0.2
		bulletCounter += 1
		Fire()
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return dieState
	#move player backwards
	if parent.lbp == "l":
		parent.velocity.x = move_toward(0, -parent.velocity.x, 50)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, -50)
	#apply a little bit of gravity
	if parent.velocity.y != 0:
		parent.velocity.y += gravity * delta * .075
	if Input.is_action_just_pressed("dash") and !parent.usedDash:
		return dashState
	if parent.velocity.y != 0:
		return fallState
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
