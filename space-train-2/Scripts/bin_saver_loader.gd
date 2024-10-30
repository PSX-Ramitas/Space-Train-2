class_name BinarySaverLoader
extends Node
# On windows can be found at %APPDATA%\Godot\app_userdata\[project_name]
const SAVE_GAME_PATH = "user://savegame.data" #user folder is guaranteed to be writable when the game is exported

@onready var player: Player = $"../../PlayerSS"

func save_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	
	var saved_data = {}
	
	saved_data["player_global_position"] = player.global_position
	saved_data["player_health"] = player.health
	
	file.store_var(saved_data)
	file.close()

func load_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	
	var saved_data = file.get_var()
	
	player.global_position =  saved_data["player_global_position"]
	player.health =  saved_data["player_health"]
	file.close()

# Example of saving the game when pressing a specific key (e.g., "S" for save)
func _process(delta):
	if Input.is_action_just_pressed("ui_save"):
		save_game()
# Example of loading the game when pressing a specific key (e.g., "L" for load)
	if Input.is_action_just_pressed("ui_load"):
		load_game()
