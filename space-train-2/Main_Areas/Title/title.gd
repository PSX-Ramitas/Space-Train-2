extends Control

@onready var start: Button = $Start
@onready var quit: Button = $Quit
@onready var temp_level_select: Control = $TempLevelSelect
@onready var options: Button = $Options
@onready var settings: Control = $Settings
@onready var load_game: Button = $LoadGame


func _on_start_pressed() -> void:
	start.visible = false
	options.visible = false
	quit.visible = false
	load_game.visible = false
	temp_level_select.visible = true

func _on_options_pressed() -> void:
	start.visible = false
	options.visible = false
	quit.visible = false
	load_game.visible = false
	settings.visible = true
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_temp_level_select_back_pressed() -> void:
	start.visible = true
	options.visible = true
	quit.visible = true
	load_game.visible = true
	temp_level_select.visible = false

func _on_temp_level_select_mult_ui_pressed() -> void:
	pass

func _on_multiplayer_ui_back_pressed() -> void:
	temp_level_select.visible = true

func _on_settings_back_button() -> void:
	start.visible = true
	options.visible = true
	quit.visible = true
	load_game.visible = true
	settings.visible = false


func _on_load_game_pressed() -> void:
	start.visible = false
	options.visible = false
	quit.visible = false
	load_game.visible = false
	temp_level_select.visible = true
