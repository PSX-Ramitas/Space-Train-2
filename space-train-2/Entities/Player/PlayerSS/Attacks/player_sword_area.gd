extends Area2D

var attack
var attacker
func _ready() -> void:
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
	elif attacker is not Player and area is VineHurtbox: #for the new vine enemies can update this later
		area.take_damage(attack)
		print("area.name that took damage: ", area.name)
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
		
