extends Node

#may need to change to children for multiplayer
@onready var camera = find_child("Camera2D")
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var level_music: AudioStreamPlayer = $LevelMusic
@onready var player: Player = $PlayerSS

var levelFinished: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_music.play()
	camera.limit_left = -150
	camera.limit_top = -119
	camera.limit_bottom = 1196
	camera.limit_right = 13030
	levelFinished = false
	transition.play_transition("DiamondIn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerData.is_dead:
		level_music.stop()

func _on_transition_screen_body_entered(body: Node2D) -> void:
	if body is Player:
		levelFinished = true
		transition.play_transition("DiamondOut")
		var sfx = self.find_child("transitionScreen")
		sfx.play_trans_sound()

func _on_transition_finished() -> void:
	if levelFinished == true:
		LevelManager.loadLevel()
