extends Area2D

@export var damage : int
@export var player : Player2
@export var facing_shape : FacingCollisionShape2D
@onready var attack_area: Area2D = $"."
var attack

func _ready():
	attack_area.monitoring = false
	monitoring = false
	damage = player.attack
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "enemy":
			if area.get_parent() is SpikesClass:
				print("YES SPIKES",area.name)
				return
			elif area.get_parent() is not Player and area.get:
				area.take_damage(attack)

func _on_body_entered(body) -> void:
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
