extends Area2D

var attack

func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		print("Parent ", parent_node)
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)
	else:
		print("No parent found.")



func _on_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		area.take_damage(attack)
		print(area.name)
		print(area.get_parent().health)
