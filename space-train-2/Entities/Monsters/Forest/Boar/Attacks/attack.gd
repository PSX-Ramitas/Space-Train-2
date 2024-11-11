extends State2

@export var return_state : State2
@export var return_animation_node : String = "walk"
@export var attack1_name : String = "run"

@onready var timer: Timer = $AttackTimer

func on_enter():
	print("ENTERED ATTACK STATE")
	character.used_dash = true
	timer.start()
	character.speed = 150

func on_exit():
	character.speed = 60
	if(next_state == return_state):
		print("LEAVING ATTACK STATE")
		print(return_animation_node)
		playback.travel(return_animation_node)

func _on_attack_timer_timeout() -> void:
	next_state = return_state
	playback.travel(return_animation_node)
	print("Return: "+str(next_state) + "Return:"+str(return_state))
