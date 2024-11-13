extends Area2D

@export var damage : int
@export var monster : CharacterBody2D
@export var facing_shape : CollisionShape2D
@onready var attack_area: Area2D = $"."

func _ready():
	damage = monster.attack
	monster.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		area.take_damage(damage)

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if (child is Damageable):
			var direction_to_damageable = (body.global_position - get_parent().global_position)
			var direction_sign = sign(direction_to_damageable.x)
			
			if(direction_sign > 0):
				child.hit(damage, Vector2.RIGHT)
			elif(direction_sign < 0):
				child.hit(damage, Vector2.LEFT)
			else:
				child.hit(damage, Vector2.ZERO)

func _on_player_facing_direction_changed(facing_right : bool):
	if(facing_right):
		facing_shape.position = facing_shape.facing_right_position
	else:
		facing_shape.position = facing_shape.facing_left_position
