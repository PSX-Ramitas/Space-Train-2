extends Control

@onready var pause_menu: Control = $"."
var game_paused = false #Flag to detect if game is paused
@onready var pause_buttons: GridContainer = $ColorRect/GridContainer
@onready var settings: Control = $ColorRect/Settings


# Called when the node enters the scene tree for the first time.
func pause_game():
	if game_paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float):
	if Input.is_action_just_pressed("pause"):
		pause_game()

func _on_resume_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false

func _on_options_pressed() -> void:
	pause_buttons.hide()
	settings.show()

func _on_forfeit_pressed() -> void: #Will change this so that it switches you back to the hub
	print("lol loser")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main_Areas/Title/title_screen.tscn")
	LevelManager.resetLevelState()
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_back_button() -> void:
	pause_buttons.show()
	settings.hide()
