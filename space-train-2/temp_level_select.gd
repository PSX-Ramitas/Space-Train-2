extends Control

signal multUI_pressed
signal back_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hub_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Areas/Spaceship (hub)/Scenes/spaceship_(hub).tscn")


func _on_forest_1_pressed() -> void:
	print("changing scene to forest room 1")
	get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Forest_room_1.tscn")


func _on_mult_ui_pressed() -> void:
	multUI_pressed.emit()

func _on_back_pressed() -> void:
	back_pressed.emit()
