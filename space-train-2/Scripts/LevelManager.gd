extends Node

# Called when the node enters the scene tree for the first time.
var levels = [
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_1.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_2.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_3.tscn",
	"res://Main_Areas/Planets/Forest/Scenes/Forest_room_4.tscn"
]

var levelCount = levels.size()
var currLevel
var visited = { }

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
			get_tree().change_scene_to_file("res://Main_Areas/Title/title_screen.tscn")
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
