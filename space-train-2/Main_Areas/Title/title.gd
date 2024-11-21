extends Control

@onready var start: Button = $Start
@onready var quit: Button = $Quit
@onready var temp_level_select: Control = $TempLevelSelect
@onready var options: Button = $Options
@onready var settings: Control = $Settings


func _on_start_pressed() -> void:
	start.visible = false
	options.visible = false
	quit.visible = false
	temp_level_select.visible = true

func _on_options_pressed() -> void:
	start.visible = false
	options.visible = false
	quit.visible = false
	settings.visible = true
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_temp_level_select_back_pressed() -> void:
	start.visible = true
	options.visible = true
	quit.visible = true
	temp_level_select.visible = false

func _on_temp_level_select_mult_ui_pressed() -> void:
	pass

func _on_multiplayer_ui_back_pressed() -> void:
	temp_level_select.visible = true

func _on_settings_back_button() -> void:
	start.visible = true
	options.visible = true
	quit.visible = true
	settings.visible = false

#WILL BE DELETED WHEN DONE
#temp just to make it easier for me to test
func _on_temp_level_testing_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Forest_room_TempTest.tscn")
