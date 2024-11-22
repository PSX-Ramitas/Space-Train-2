extends Node

# Called when the node enters the scene tree for the first time.
var levels = [
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_1.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_2.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_3.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_4.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/forest_room_5.tscn",
	"res://Main_Areas/Planets/Forest/forest_room_6.tscn"
]

var levelCount = 4
var currLevel
var visited = { }
var worldClear = false
func resetLevelState():
	levelCount = 4  # Reset the level count back to the full set
	PlayerData.maxHealth = PlayerData.initHealth
	PlayerData.health = PlayerData.maxHealth
	visited.clear()  # Clear the visited levels
	print("Level state reset: ", visited)
	
func loadLevel():
	var found = false
	while found == false:
		currLevel = randi() % levels.size()
		if visited.get(currLevel) != true:
			found = true
			levelCount -= 1
			visited[currLevel] = true
			get_tree().change_scene_to_file(levels[currLevel])
			print(visited)
		#else:
			#currLevel = randi() % levels.size()
			#if visited.get(currLevel) != true:
				#found = true
		if levelCount == 0:
			worldClear = true
			resetLevelState()
			get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/forest_portal.tscn")
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
