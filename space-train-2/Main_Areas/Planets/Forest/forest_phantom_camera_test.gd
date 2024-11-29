extends Node2D
@onready var arena_cam: PhantomCamera2D = $"Arena Cam"
@onready var player_p_cam: PhantomCamera2D = $PlayerPCam
@onready var tile_map: TileMap = $TileMap
@onready var boar: CharacterBody2D = $Boar

var boar_defeated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map.set_layer_enabled(0, false) #Disable arena gate
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !boar_defeated:
		await boar.tree_exiting #Wait til boar is queue_freed to adjust flag and reset camera back to player
		boar_defeated = true
		arena_cam.priority = 0
		player_p_cam.priority = 1
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.GLUED #Ensures camera goes back to centering the player
		await player_p_cam.tween_completed
		player_p_cam.follow_mode = PhantomCamera2D.FollowMode.FRAMED #After the camera recenters around player, re-add static box
	if boar_defeated:
		tile_map.set_layer_enabled(0, false) #On boar defeated, remove arena gates


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox and !boar_defeated: #Upon entering arena, set arena camera to higher priority and add gates 
		arena_cam.priority = 1
		player_p_cam.priority = 0
		tile_map.set_layer_enabled(0, true)
