extends Node2D
var teleportable = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teleportable:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Forest_room_2.tscn")


func TeleporterAreaBodyEntered(body: Node2D) -> void:
	teleportable = true
	print(str(body) + "entered")
	pass # Replace with function body.


func TeleporterAreaBodyExited(body: Node2D) -> void:
	teleportable = false
	print(str(body) + "exited")
	pass # Replace with function body.
