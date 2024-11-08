extends Area2D

@export var damage : int = 10
@export var player : Player2
@export var facing_shape : FacingCollisionShape2D
@onready var attack_area: Area2D = $"."

func _ready():
	attack_area.monitoring = false
	monitoring = false
	print(monitoring)
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_body_entered(body) -> void:
	print(monitoring)
	for child in body.get_children():
		if (child is Damageable):
			print(body.name)
			child.hit(damage)

func _on_player_facing_direction_changed(facing_right : bool):
	if(facing_right):
		facing_shape.position = facing_shape.facing_right_position
	else:
		facing_shape.position = facing_shape.facing_left_position
