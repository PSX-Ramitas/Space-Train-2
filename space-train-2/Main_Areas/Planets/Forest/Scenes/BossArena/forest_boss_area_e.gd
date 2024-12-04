extends Node2D
@onready var player_cam: PhantomCamera2D = $PlayerCam
@onready var entrance_cam: PhantomCamera2D = $EntranceCam
@onready var transition: TransitionScreen = $TransitionScreen/TransitionAnim
@onready var label: Label = $Entrance/Label
@onready var level_music: AudioStreamPlayer = $LevelMusic
@onready var zoom_cam: Area2D = $EntranceCamDetection
@onready var player_ss: Player = $PlayerSS
@onready var transition_sound: AudioStreamPlayer = $TransitionSound

var dungeonEntered: bool
var in_dungeon_entrance:bool
var musicFadeTimer: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dungeonEntered = false
	in_dungeon_entrance = false
	level_music.play()
	player_cam.limit_left = -72
	player_cam.limit_top = -124
	player_cam.limit_bottom = 900
	player_cam.limit_right = 4312
	transition.play_transition("DiamondIn")
	player_cam.priority = 1
	entrance_cam.priority = 0
	label.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_dungeon_entrance and Input.is_action_just_pressed("conversation_start"):
		transition_sound.play()
		dungeonEntered = true
		transition.play_transition("FadeOut")
		player_ss.active = false
	var playerArea = player_ss.playerHitBox
	if zoom_cam.overlaps_area(playerArea) and musicFadeTimer > 0.0:
		level_music.volume_db -= 0.03
		musicFadeTimer -= delta
	elif level_music.volume_db < -20.0 and musicFadeTimer < 1.0:
		level_music.volume_db += 0.03
		musicFadeTimer += delta
		
func _on_entrance_cam_detection_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		entrance_cam.priority = 1
		player_cam.priority = 0


func _on_entrance_cam_detection_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		player_cam.priority = 1
		entrance_cam.priority = 0
		player_cam.follow_mode = PhantomCamera2D.FollowMode.GLUED #Ensures camera goes back to centering the player
		await player_cam.tween_completed
		player_cam.follow_mode = PhantomCamera2D.FollowMode.FRAMED #After the camera recenters around player, re-add static box
	

func _on_entrance_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		label.visible = true
		in_dungeon_entrance = true

func _on_entrance_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		label.visible = false
		in_dungeon_entrance = false


func _on_transition_finished() -> void:
	if dungeonEntered:
		get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Scenes/BossArena/forest_boss_area_i.tscn")
	
