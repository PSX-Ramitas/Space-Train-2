extends Node2D

@onready var player_ss: Player = $PlayerSS
@onready var player_ss_2: Player2 = $PlayerSs2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event) -> void:
	if Input.is_action_just_pressed("transform"):
		var temp_state = player_ss_2.active
		player_ss_2.active = player_ss.active
		player_ss.active = temp_state
		if(player_ss_2.active):
			player_ss_2.global_position = player_ss.global_position
		elif(player_ss.active):
			player_ss.global_position = player_ss_2.global_position
