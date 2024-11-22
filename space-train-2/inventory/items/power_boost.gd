class_name PowerBoost extends InventoryItem

@export var attack_increase: int = 1

#@export var scene: PackedScene = preload("res://Collectables/power.tscn")

func use(player: Player) -> void:
	#if player:
	
	player.increase_attack(attack_increase)  # Call increase_attack on the player
	#else:
		#print("Error: Player instance is null!")
	
