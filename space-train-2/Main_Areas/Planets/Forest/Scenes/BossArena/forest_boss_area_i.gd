extends Node2D
@onready var arena_cam: PhantomCamera2D = $"Camera and PCam/ArenaCam"
@onready var player_p_cam: PhantomCamera2D = $"Camera and PCam/PlayerCam"
@onready var tile_map: TileMap = $TileMap
@onready var player_ss: Player = $PlayerSS
@onready var portal: Node2D = $Portal
@onready var transitions: TransitionScreen = $CanvasLayer/TransitionAnim

var boar_defeated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_p_cam.limit_left = -400
	player_p_cam.limit_top = -20
	player_p_cam.limit_bottom = 760
	player_p_cam.limit_right = 12540
	transitions.play_transition("FadeIn")
	tile_map.set_layer_enabled(0, false) #Disable arena gate
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_arena_trigger_entered(area: Area2D) -> void:
	if area is PlayerHitbox: #Upon entering arena, set arena camera to higher priority and add gates 
		arena_cam.priority = 1
		player_p_cam.priority = 0
		await get_tree().create_timer(1.0).timeout
		tile_map.set_layer_enabled(0, true)
		
func _on_arena_trigger_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		arena_cam.priority = 0
		player_p_cam.priority = 1
		tile_map.set_layer_enabled(0, false)
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.GLUED #Ensures camera goes back to centering the player
		await player_p_cam.tween_completed
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.FRAMED #After the camera recenters around player, re-add static box
		

func _on_portal_warp() -> void:
	player_ss.active = false
	await portal.animations.animation_finished
	transitions.play_transition("FadeOut")


func _on_transition_finished() -> void:
	if portal.portal_used:
		get_tree().change_scene_to_file("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")
		LevelManager.worldClear = true
		LevelManager.resetLevelState()
