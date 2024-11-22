extends Control

@export var boss_killed : bool = false
@export var player_ss: Player
@export var player_ss_2: Player2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#PlayerTranformer.connect("on_swap_player", player_to_monster)
	PlayerTransformer.connect("on_swap_player", player_to_monster)

func _input(event) -> void:
	if Input.is_action_just_pressed("transform"):
		#PlayerTranformer.emit_signal("on_swap_player", player_ss, player_ss_2)
		PlayerTransformer.emit_signal("on_swap_player", player_ss, player_ss_2)

func player_to_monster(player_ss, player_ss_2):
	var temp_state = player_ss_2.active
	player_ss_2.active = player_ss.active
	player_ss.active = temp_state
	if(player_ss_2.active):
		player_ss_2.global_position = player_ss.global_position
	elif(player_ss.active):
		player_ss.global_position = player_ss_2.global_position
