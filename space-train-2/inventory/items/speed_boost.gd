class_name SpeedBoost extends InventoryItem

@export var speed_increase: int = 0.3


func use(player: Player) -> void:
	#if player:
	#var sfx = player.find_child("PowUp")
	#sfx.play()
	player.increase_speed(speed_increase)  # Call increase_attack on the player
	#else:
		#print("Error: Player instance is null!")
