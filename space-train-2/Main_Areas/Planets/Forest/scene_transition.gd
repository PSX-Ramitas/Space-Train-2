extends Area2D


func _on_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Forest_room_2.tscn")
