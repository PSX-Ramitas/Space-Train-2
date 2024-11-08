extends Node2D

const SPEED = 60
var direction = -1
var health = 20

@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	if ray_cast_2d_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
	if ray_cast_2d_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
	position.x += direction * SPEED * delta
