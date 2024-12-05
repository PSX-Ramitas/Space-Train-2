extends Node2D
@onready var arena_cam: PhantomCamera2D = $"Camera and PCam/ArenaCam"
@onready var player_p_cam: PhantomCamera2D = $"Camera and PCam/PlayerCam"
@onready var tile_map: TileMap = $TileMap
@onready var player_ss: Player = $PlayerSS
@onready var portal: Node2D = $Portal
@onready var transitions: TransitionScreen = $CanvasLayer/TransitionAnim
@onready var boss: Boss = $Boss
@onready var boss_wall: TileMap = $TileMap2
@onready var fanfare: AudioStreamPlayer = $Music/Fanfare
@onready var OminousMessage: Label = $OminousMessage/Label

@onready var level_music: AudioStreamPlayer = $Music/LevelMusic
@onready var boss_music: AudioStreamPlayer = $Music/BossMusic

var boss_defeated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_p_cam.limit_left = -400
	player_p_cam.limit_top = -20
	player_p_cam.limit_bottom = 2000
	player_p_cam.limit_right = 12540
	transitions.play_transition("FadeIn")
	tile_map.set_layer_enabled(0, false) #Disable arena gate
	level_music.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !boss_defeated:
		await boss.tree_exiting #Wait til boar is queue_freed to adjust flag and reset camera back to player
		boss_defeated = true
		if boss_music.playing:
			boss_music.stop()
		if !fanfare.playing:
			fanfare.play()
		await fanfare.finished
		fanfare.stop()
		arena_cam.priority = 0
		player_p_cam.priority = 1
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.GLUED #Ensures camera goes back to centering the player
		await player_p_cam.tween_completed
		tile_map.set_layer_enabled(0, false) #On boar defeated, remove arena gates
		if !level_music.playing:
			level_music.play()
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.FRAMED #After the camera recenters around player, re-add static box
	if boss_defeated:
		if boss_music.playing:
			boss_music.stop()

func _on_arena_trigger_entered(area: Area2D) -> void:
	if area is PlayerHitbox and !boss_defeated: #Upon entering arena, set arena camera to higher priority and add gates 
		boss_wall.set_layer_enabled(4, false)
		arena_cam.priority = 1
		player_p_cam.priority = 0
		await get_tree().create_timer(1.0).timeout
		level_music.stop()
		if !boss_music.playing:
			boss_music.play()
		tile_map.set_layer_enabled(0, true)
	elif area is PlayerHitbox and boss_defeated:
		if !boss_music.playing:
			boss_music.stop()

func _on_portal_warp() -> void:
	player_ss.active = false
	await portal.animations.animation_finished
	transitions.play_transition("FadeOut")


func _on_transition_finished() -> void:
	if portal.portal_used:
		get_tree().change_scene_to_file("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")
		LevelManager.worldClear = true
		LevelManager.resetLevelState()


func _on_ominous_message_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox and !boss_defeated:
		OminousMessage.text = "A great test of combat awaits..."
		OminousMessage.visible = true
	elif area is PlayerHitbox and boss_defeated:
		OminousMessage.text = "Well done..."
		OminousMessage.visible = true


func _on_ominous_message_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		OminousMessage.visible = false
