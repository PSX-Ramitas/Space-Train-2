class_name SaverLoader
extends Node
# On windows can be found at %APPDATA%\Godot\app_userdata\[project_name]
const SAVE_GAME_PATH = "user://savegame.json" #user folder is guaranteed to be writable when the game is exported

@onready var player: Player = $"../../PlayerSS"

func save_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	
	var saved_data = {}
	
	saved_data["player_global_position:x"] = player.global_position.x
	saved_data["player_global_position:y"] = player.global_position.y
	
	# Convert Dictionary to JSON
	var json = JSON.stringify(saved_data)
	
	file.store_string(json)
	file.close()

func load_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	
	var json = file.get_as_text()
	
	# Conver JSON to Dictionary
	var saved_data = JSON.parse_string(json)
	
	player.global_position.x =  saved_data["player_global_position:x"]
	player.global_position.y =  saved_data["player_global_position:y"]
	file.close()

# Example of saving the game when pressing a specific key (e.g., "S" for save)
func _process(delta):
	if Input.is_action_just_pressed("ui_save"):
		save_game()
# Example of loading the game when pressing a specific key (e.g., "L" for load)
	if Input.is_action_just_pressed("ui_load"):
		load_game()
