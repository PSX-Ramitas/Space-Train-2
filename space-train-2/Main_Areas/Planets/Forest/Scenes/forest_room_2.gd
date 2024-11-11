extends Node

#may need to change to children for multiplayer
@onready var camera = find_child("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.limit_left = 50
	camera.limit_top = 0
	camera.limit_bottom = 950
	camera.limit_right = 1900
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_transition_screen_body_entered(body: Node2D) -> void:
	var enemies = $Enemies.get_children()
	print(enemies)
	if body is Player and enemies.is_empty():
		LevelManager.loadLevel()
