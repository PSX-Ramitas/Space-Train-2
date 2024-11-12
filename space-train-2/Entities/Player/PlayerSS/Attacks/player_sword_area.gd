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
	elif attacker is Projectile:
		pass
	elif attacker is not Player and area is EnemyHitbox:
			area.take_damage(attack)
			print("area.name that took damage: ", area.name)
	else: 
		print("idk man :()")
			
