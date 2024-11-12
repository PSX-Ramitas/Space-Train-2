extends Area2D

var sword_area
var attack = 3
#@onready var player_hitbox = $PlayerHitbox

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		print("Area is null")
		return
		
	if area is PlayerHitbox or area.has_method("take_damage"):
			print("taking damage")
			area.take_damage(attack)
			
	print(area.name)
