extends Control
@onready var test_sfx: AudioStreamPlayer = $TestSFX
@onready var input_settings: Control = $InputSettings
@onready var main_settings: MarginContainer = $MainSettings

signal backButton
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)

func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1: 
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on_back_pressed() -> void:
	backButton.emit()
	

func _on_input_controls_pressed() -> void:
	main_settings.visible = false
	input_settings.visible = true


func _on_input_settings_back_pressed() -> void:
	main_settings.visible = true
	input_settings.visible = false
