extends Area2D

var sword_area
var attack = 3
#@onready var player_hitbox = $PlayerHitbox

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		print("Area is null")
		return
		
	if area.name=="PlayerHitbox":
			print("taking damage")
			area.take_damage(attack)
	elif area.has_method("take_damage"):
		print("area able to take damage from botwheel projectile")
		area.take_damage(attack)
	else: 
		#print("Error: area does not have a take_damage method")
		return	
			
	queue_free()
	print(area.name)
