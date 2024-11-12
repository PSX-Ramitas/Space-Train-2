extends Area2D

var sword_area
var attack = 3
@onready var player_hitbox = $PlayerHitbox

func _on_area_entered(area: Area2D) -> void:
	# Ensure area is valid
	if area == null:
		print("Area is null")
		return
		
	# Ensure the parent of the area is a valid Player
	if area.get_parent() and area.get_parent() is Player:
		var sword_area_node = $PlayerSwordArea  # Try to get the node
		
		if sword_area_node == null:
			print("PlayerSwordArea node not found!")
			return
		
		sword_area = sword_area_node.name
		print("player in bulletarea")
		print("attack damage", attack)

		# Now check for the sword_area match (area should not be null before this)
		if area != null and area.name == sword_area:
			pass
		else:
			# Ensure that take_damage exists before calling
			if area.has_method("take_damage"):
				print("taking damage")
				area.take_damage(attack)
			else:
				print("Error: area does not have a take_damage method")
			queue_free()
			print(area.name)
	else: 
		print("Did not hit hitbox")
