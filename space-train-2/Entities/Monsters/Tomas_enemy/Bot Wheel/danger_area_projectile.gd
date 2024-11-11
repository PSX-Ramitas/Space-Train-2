extends Area2D

var attack=3
@onready var player_hitbox =$PlayerHitbox


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("player in bulletarea")
		print("attack damage", attack)
		if player_hitbox:
			area.take_damage(attack)
			queue_free()
			print(area.name)
	else: 
		"didnt hit enemy"
