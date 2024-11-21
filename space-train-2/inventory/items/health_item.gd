class_name HealthItem extends InventoryItem

#@onready var inventory: Inventory = preload("res://inventory/playerinventory.tres")
#@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
#@onready var player: Player = get_node("res://Enities/Player/PlayerSS/player_ss.gd") 

@export var health_increase: int = 1

#func use(player: Player) -> void:
	#print("called")
	#player.increase_health(health_increase)
#	pass
#func use(area1: Area2D) -> void:
	#area1.increase_health(health_increase)
