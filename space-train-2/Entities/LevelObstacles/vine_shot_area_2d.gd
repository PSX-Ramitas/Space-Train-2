extends Area2D
@onready var projectile: Projectile = $".."

var sword_area
var attack = 15
#@onready var player_hitbox = $PlayerHitbox

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		print("Area is null")
		return
	
	if area.name=="PlayerHitbox":
			print("playerhitbox taking damage")
			area.take_damage(attack)
			projectile.queue_free()
	else: 
		#print("Error: area does not have a take_damage method")
		return	
	queue_free()
	#print(area.name)
