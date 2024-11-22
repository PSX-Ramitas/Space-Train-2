extends Node

@onready var camera = find_child("Camera2D")
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var level_music: AudioStreamPlayer = $LevelMusic

var levelFinished: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_music.play()
	camera.limit_left = 0
	camera.limit_top = 10
	camera.limit_bottom = 800
	camera.limit_right = 3000
	levelFinished = false
	transition.play_transition("DiamondIn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerData.is_dead:
		level_music.stop()


func _on_transition_screen_body_entered(body: Node2D) -> void:
	var enemies = $Enemies.get_children()
	print(enemies)
	var sfx = self.find_child("transitionScreen")
	if body is Player and enemies.is_empty():
		levelFinished = true
		transition.play_transition("DiamondOut")
		sfx.play_trans_sound()
	elif body is Player and !enemies.is_empty():
		sfx.play_buzzer_sound()

func _on_transition_finished() -> void:
	if levelFinished == true:
		LevelManager.loadLevel()
