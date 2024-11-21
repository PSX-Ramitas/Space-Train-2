extends Area2D

var attack
var attacker
var can_attack
func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)


func _on_area_entered(area: Area2D) -> void:
	can_attack = true
	attacker = area.get_parent()
	print(attacker.name, " IN BOSS SWORD AREA")
#	_dealing_damage(attacker)
	if attacker is Player and area is PlayerHitbox:
		area.take_damage(attack)
		print("boss attacking area: ", area.name)
		return
	else:
		pass
func _on_area_exited(area: Area2D) -> void:
	can_attack = false


#func _dealing_damage(attacker)-> void:
#	if attacker is Player and attacker.child.get_node("PlayerHitbox"):
#		attacker.child.get_node.take_damage(attack)
#		print("boss attacking area: ", attacker.name)
#	else:
#		pass





#		for child in attacker.get_children():
#			if (child is Damageable):
#				print ("damaging with 3rd damage else statemetn")
#				var direction_to_damageable = (area.global_position - get_parent().global_position)
#				var direction_sign = sign(direction_to_damageable.x)
#				
#				if(direction_sign > 0):
#					child.hit(attack, Vector2.RIGHT)
#				elif(direction_sign < 0):
#					child.hit(attack, Vector2.LEFT)
#				else:
#					child.hit(attack, Vector2.ZERO)
