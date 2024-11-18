extends Control

signal multUI_pressed
signal back_pressed
@onready var transitionPlayer: TransitionScreen = $"../../CanvasLayer/TransitionAnim"
var level_pressed: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_pressed = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hub_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Areas/Spaceship (hub)/Scenes/spaceship_(hub).tscn")


func _on_forest_1_pressed() -> void:
	#get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Forest_room_1.tscn")
	level_pressed = true
	transitionPlayer.play_transition("FadeOut")


func _on_mult_ui_pressed() -> void:
	multUI_pressed.emit()

func _on_back_pressed() -> void:
	back_pressed.emit()

func _on_transition_finished() -> void:
	if level_pressed == true:
		level_pressed == false
		LevelManager.loadLevel()
