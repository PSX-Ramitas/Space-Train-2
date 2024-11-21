extends Control

@onready var start: Button = $Start
@onready var quit: Button = $Quit
@onready var temp_level_select: Control = $TempLevelSelect
@onready var options: Button = $Options
@onready var settings: Control = $Settings
@onready var button_press: AudioStreamPlayer = $"../Sounds/ButtonPress"
@onready var back_button_press: AudioStreamPlayer = $"../Sounds/BackButtonPress"
@onready var transition_anim: TransitionScreen = $"../CanvasLayer/TransitionAnim"


func _on_start_pressed() -> void:
	button_press.play()
	start.visible = false
	options.visible = false
	quit.visible = false
	temp_level_select.visible = true

func _on_options_pressed() -> void:
	button_press.play()
	start.visible = false
	options.visible = false
	quit.visible = false
	settings.visible = true
	
func _on_quit_pressed() -> void:
	back_button_press.play()
	transition_anim.play_transition("FadeOut")
	await transition_anim.anim_finished
	get_tree().quit()

func _on_temp_level_select_back_pressed() -> void:
	back_button_press.play()
	start.visible = true
	options.visible = true
	quit.visible = true
	temp_level_select.visible = false

func _on_temp_level_select_mult_ui_pressed() -> void:
	pass

func _on_multiplayer_ui_back_pressed() -> void:
	temp_level_select.visible = true

func _on_settings_back_button() -> void:
	button_press.play()
	start.visible = true
	options.visible = true
	quit.visible = true
	settings.visible = false
