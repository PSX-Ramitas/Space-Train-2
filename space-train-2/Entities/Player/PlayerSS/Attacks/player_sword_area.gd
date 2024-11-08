extends Area2D

var attack

func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack Power: ", attack)

func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.get_parent() is SpikesClass:
		print("YES SPIKES",area.name)
		return
	elif area.get_parent() is not Player and area.get:
		#area.take_damage(attack)
		print(area.name)
		
	for child in area.get_children():
		if (child is Damageable):
			child.hit(attack)

func _on_body_entered(body: Node2D) -> void:
	print(body.name + "entered body")
	for child in body.get_children():
		if (child is Damageable):
			var direction_to_damageable = (body.global_position - get_parent().global_position)
			var direction_sign = sign(direction_to_damageable.x)
			
			if(direction_sign > 0):
				child.hit(attack, Vector2.RIGHT)
			elif(direction_sign < 0):
				child.hit(attack, Vector2.LEFT)
			else:
				child.hit(attack, Vector2.ZERO)
