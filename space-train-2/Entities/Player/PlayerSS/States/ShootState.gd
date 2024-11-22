extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var projectile :PackedScene

var nextState: State
var attackFinished: bool

func enter() -> void:
	var sfx = parent.find_child("Sword3")
	sfx.play()
	parent.sword.monitoring = false
	#kill y movement so that it can not be abused to jump higher
	parent.velocity.y = 0
	#used to move the player forwards a bit
	if(parent.lbp == "l"):
		parent.velocity.x = dashVelocity * 0.2
	else:
		parent.velocity.x = -dashVelocity * 0.2
	Fire()
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:

	if parent.health <= 0:
		return dieState
	#move player backwards
	parent.velocity.x = move_toward(parent.velocity.x, 0, -50)
	#apply a little bit of gravity
	parent.velocity.y += gravity * delta * .075
	# only one attack while in air:
	return idleState

@rpc("any_peer", "call_local")
func Fire():
	var b = projectile.instantiate()
	b.global_position = $"../../ProjectileSpawn".global_position
	get_tree().root.add_child(b)


@rpc("any_peer", "call_local")
func FinishedAttack():
	attackFinished = true
func _on_animated_sprite_2d_animation_finished() -> void:
	FinishedAttack()
