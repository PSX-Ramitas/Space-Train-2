extends Node

#may need to change to children for multiplayer
@onready var camera = find_child("Camera2D")
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var level_music: AudioStreamPlayer = $LevelMusic
@onready var speedTime: Panel = $CanvasLayer/SpeedrunTimer
@onready var player: Player = $PlayerSS
@onready var yay: AudioStreamPlayer = $yay

var levelFinished: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedTime.set_timer(45)
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
		if !yay.playing:
			yay.play()
		speedTime.stop_timer()
		await get_tree().create_timer(1.0).timeout
		levelFinished = true
		transition.play_transition("DiamondOut")
		var sfx = self.find_child("transitionScreen")
		sfx.play_trans_sound()

func _on_transition_finished() -> void:
	if levelFinished == true:
		LevelManager.loadLevel()


func _on_race_line_entered(area: Area2D) -> void:
	if !level_music.playing:
		level_music.play()
	speedTime.start_timer()

func _on_speedrun_timer_timed_out() -> void:
	var corpse = player.find_child("PlayerHitbox")
	corpse.take_damage(PlayerData.maxHealth)
