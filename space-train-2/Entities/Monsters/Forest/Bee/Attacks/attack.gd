extends State2

@export var return_state : State2
@export var return_animation_node : String = "fly"
@export var attack1_name : String = "attack"

@onready var timer: Timer = $AttackTimer

func on_enter():
	character.used_dash = true
	timer.start()
	character.speed = 150

func on_exit():
	character.speed = 60
	if(next_state == return_state):
		playback.travel(return_animation_node)

func _on_attack_timer_timeout() -> void:
	next_state = return_state
	playback.travel(return_animation_node)
