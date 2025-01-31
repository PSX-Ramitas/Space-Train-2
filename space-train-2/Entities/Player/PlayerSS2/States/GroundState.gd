extends State2

class_name GroundState

@export var jump_velocity : int = -400.0
@export var air_state: State2
@export var jump_animation : String = "jump_start"
@export var attack_state: State2
@export var attack_animation : String = "attack1"
@onready var buffer_timer: Timer = $BufferTimer

func state_process(delta):
	if(!character.is_on_floor() && buffer_timer.is_stopped()):
		next_state = air_state

func state_input(event : InputEvent):
	if(event.is_action_pressed("jump")):
		jump()
	if(event.is_action_pressed("attack_melee")):
		attack()

func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)

func attack():
	next_state = attack_state
	playback.travel(attack_animation)
