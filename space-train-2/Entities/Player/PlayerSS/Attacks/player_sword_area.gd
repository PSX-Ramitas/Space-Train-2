extends Area2D

var attack
var in_hitbox = []  # Track entities in the hitbox

func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is SpikesClass:
		print("YES SPIKES", area.name)
		return
	elif area.get_parent() is not Player and area.get_parent() is Entity:
		if area.is_alive and area not in in_hitbox:
			in_hitbox.append(area)  # Add entity to in_hitbox list
		print(area.name, " entered hitbox")


func _on_area_exited(area: Area2D) -> void:
	if area in in_hitbox:
		in_hitbox.erase(area)  # Remove entity when it leaves the hitbox
		print(area.name, " exited hitbox")


# Call this function each time the player inputs an attack
func apply_attack() -> void:
	for area in in_hitbox:
		if area.get_parent() is not Player and area.get_parent() is Entity:
			area.take_damage(attack)
			print("Damaged", area.name)
			if area.is_alive == false:
				in_hitbox.erase(area)
