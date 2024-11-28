extends Node2D
@onready var arena_cam: PhantomCamera2D = $"Arena Cam"
@onready var player_p_cam: PhantomCamera2D = $PlayerPCam
@onready var tile_map: TileMap = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map.set_layer_enabled(0, false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		arena_cam.priority = true
		player_p_cam.priority = false
		tile_map.set_layer_enabled(0, true)
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		arena_cam.priority = false
		player_p_cam.priority = true
		tile_map.set_layer_enabled(0, false)
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.GLUED
		await player_p_cam.tween_completed
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.FRAMED
