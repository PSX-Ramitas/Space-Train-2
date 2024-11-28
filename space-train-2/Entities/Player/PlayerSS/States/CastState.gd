extends State

@export var idleState: State
@export var jumpState: State
@export var fallState: State
@export var dashState: State
@export var dieState: State
@export var moveState: State

var nextState: State
var attackFinished: bool
var bulletCounter: int = 0

var cast

func enter() -> void:
	var hitbox = parent.find_child("PlayerHitbox")
	cast = parent.find_child("Cast")
	hitbox.can_hurt = true
	parent.sword.monitoring = false
	#used to move the player forwards a bit
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if parent.lbp == "l":
		cast.position = Vector2(-90.5, -15)
		cast.flipped(true)
	else:
		cast.position = Vector2(18.5, -15)
		cast.flipped(false)
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
func FinishedAttack():
	attackFinished = true
func _on_animated_sprite_2d_animation_finished() -> void:
	FinishedAttack()
