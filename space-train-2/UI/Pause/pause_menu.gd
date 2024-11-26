extends Control

@onready var pause_menu: Control = $"."
var game_paused = false #Flag to detect if game is paused
@onready var pause_buttons: GridContainer = $ColorRect/GridContainer
@onready var settings: Control = $ColorRect/Settings
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var pause_sound: AudioStreamPlayer = $Sounds/PauseSound
@onready var button_press: AudioStreamPlayer = $Sounds/ButtonPress
@onready var back_button_press: AudioStreamPlayer = $Sounds/BackButtonPress


# Called when the node enters the scene tree for the first time.
func pause_game():
	if game_paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true
	pause_sound.play()
	game_paused = !game_paused

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float):
	if Input.is_action_just_pressed("pause"):
		pause_game()

func _on_resume_pressed() -> void:
	pause_menu.hide()
	back_button_press.play()
	pause_sound.play()
	get_tree().paused = false
	game_paused = !game_paused

func _on_options_pressed() -> void:
	button_press.play()
	pause_buttons.hide()
	settings.show()

func _on_forfeit_pressed() -> void: #Will change this so that it switches you back to the hub
	print("lol loser")
	button_press.play()
	get_tree().paused = false
	game_paused = !game_paused
	PlayerData.forfeited = true
	transition.play_transition("FadeOut")
	
func _on_exit_pressed() -> void:
	button_press.play()
	await button_press.finished
	get_tree().quit()

func _on_settings_back_button() -> void:
	pause_buttons.show()
	settings.hide()

func _on_transition_finished() -> void:
	get_tree().change_scene_to_file("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")
	LevelManager.resetLevelState()
