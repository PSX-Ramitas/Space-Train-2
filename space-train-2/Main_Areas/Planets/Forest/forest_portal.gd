extends Node2D
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var level_music: AudioStreamPlayer = $LevelMusic
@onready var player_ss: Player = $PlayerSS
@onready var portal: Node2D = $Portal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.play_transition("DiamondIn")
	level_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_warp() -> void:
	player_ss.active = false
	await portal.animations.animation_finished
	transition.play_transition("FadeOut")


func _on_transition_finished() -> void:
	if portal.portal_used:
		get_tree().change_scene_to_file("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")
