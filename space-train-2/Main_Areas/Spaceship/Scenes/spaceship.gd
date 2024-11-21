extends Node2D
var teleportable = false

var radius = 200
var omega = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.offset.x = radius * cos(omega)
	animated_sprite_2d.offset.y = radius * sin(omega)
	if teleportable:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://Main_Areas/Planets/Forest/Forest_room_1.tscn")


func TeleporterAreaBodyEntered(body: Node2D) -> void:
	teleportable = true
	print(str(body) + "entered")
	pass # Replace with function body.


func TeleporterAreaBodyExited(body: Node2D) -> void:
	teleportable = false
	print(str(body) + "exited")
	pass # Replace with function body.


func _on_planet_rotation_timeout() -> void:
	if(omega > 6.28319):
		omega = 0
	omega += 0.005
