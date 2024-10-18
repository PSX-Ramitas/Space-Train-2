extends Area2D

var attack

func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Player:
		area.take_damage(attack)
		print(area.name)
