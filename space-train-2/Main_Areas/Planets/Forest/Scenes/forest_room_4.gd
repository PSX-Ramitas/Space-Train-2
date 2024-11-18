extends Node

@onready var camera = find_child("Camera2D")
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim

var levelFinished: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.limit_left = 0
	camera.limit_top = 10
	camera.limit_bottom = 800
	camera.limit_right = 3000
	levelFinished = false
	transition.play_transition("DiamondIn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_transition_screen_body_entered(body: Node2D) -> void:
	var enemies = $Enemies.get_children()
	print(enemies)
	if body is Player and enemies.is_empty():
		levelFinished = true
		transition.play_transition("DiamondOut")
		

func _on_transition_finished() -> void:
	if levelFinished == true:
		LevelManager.loadLevel()
