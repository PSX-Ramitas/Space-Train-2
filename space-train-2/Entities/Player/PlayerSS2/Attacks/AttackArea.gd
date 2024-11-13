extends Area2D

@export var player : Player2
@export var facing_shape : FacingCollisionShape2D
@onready var attack_area: Area2D = $"."
var attack
var attacker

func _ready():
	attack_area.monitoring = false
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)
	
func _on_area_entered(area: Area2D) -> void:
	attacker = area.get_parent()
	print(attacker.name, "IN SWORD AREA")
	if attacker is SpikesClass:
		print("YES SPIKES",area.name)
		return
	elif attacker is not Player and area is EnemyHitbox:
			area.take_damage(attack)
			print("area.name that took damage: ", area.name)
	else:
		for child in attacker.get_children():
			if (child is Damageable):
				var direction_to_damageable = (area.global_position - get_parent().global_position)
				var direction_sign = sign(direction_to_damageable.x)
				
				if(direction_sign > 0):
					child.hit(attack, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(attack, Vector2.LEFT)
				else:
					child.hit(attack, Vector2.ZERO)

func _on_player_facing_direction_changed(facing_right : bool):
	if(facing_right):
		facing_shape.position = facing_shape.facing_right_position
	else:
		facing_shape.position = facing_shape.facing_left_position
