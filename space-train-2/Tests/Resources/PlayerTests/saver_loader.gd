class_name TestSaverLoader
extends Node
# On windows can be found at %APPDATA%\Godot\app_userdata\[project_name]
const SAVE_GAME_PATH = "res://Tests/Resources/PlayerTests/savegame.json" #user folder is guaranteed to be writable when the game is exported
var current_scene_path = "res://Tests/Resources/PlayerTests/"  # Set a default scene path

@export var player: Player
@export var player2: Player2

var loaded_data = {}

func _ready():
	if(player):
		pass
	elif(player2):
		pass

func save_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	
	var saved_data = {}
	
	saved_data["player_global_position:x"] = player.global_position.x
	saved_data["player_global_position:y"] = player.global_position.y
	saved_data["player_health"] = player.health
	saved_data["player_health_bar"] = player.health
	saved_data["current_scene_path"] = get_tree().current_scene.get_name()
	
	# Convert Dictionary to JSON
	var json = JSON.stringify(saved_data)
	
	file.store_string(json)
	file.close()

func load_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	
	var json = file.get_as_text()
	
	# Conver JSON to Dictionary
	var saved_data = JSON.parse_string(json)
	loaded_data = JSON.parse_string(json)
	get_tree().change_scene_to_file(current_scene_path+saved_data["current_scene_path"]+".tscn")
	
	file.close()

func load_position():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	
	var json = file.get_as_text()
	
	var saved_data = JSON.parse_string(json)
	
	player.global_position.x = saved_data["player_global_position:x"]
	player.global_position.y = saved_data["player_global_position:y"]
	player.health = saved_data["player_health"]
	
	file.close()

# Example of saving the game when pressing a specific key (e.g., "ctrl+s" for save)
func _process(delta):
	if Input.is_action_just_pressed("ui_save"):
		save_game()
# Example of loading the game when pressing a specific key (e.g., "ctrl+l" for load)
	if Input.is_action_just_pressed("ui_load"):
		print(player.global_position.x)
		load_game()
	if Input.is_action_just_pressed("test"):
		print("loading")
		load_position()
