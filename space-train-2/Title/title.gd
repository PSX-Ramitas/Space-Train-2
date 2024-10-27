extends Control




func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/temp_level_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
