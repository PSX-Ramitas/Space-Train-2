extends Control

#signal use_item

var isOpen: bool = false
var amountHeal = 5
@onready var inventory: Inventory = preload("res://inventory/playerinventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var area: Area2D = $"../../PlayerHitbox"
#@onready var player: Player = get_node("res://Entities/Player/PlayerSS/player_ss.gd")

func _ready():
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_use_item"):
		var item = inventory.items[0]  # Get the item from the first slot
		if item and item is HealthItem:  # Check if it's a HealthItem
			area.heal_health(amountHeal)
		inventory.use_item_at_index(0)
		clear_inventory()
		
func count_items_in_inventory() -> int:
	var count = 0
	for item in inventory.items:
		if item:
			count += 1
	return count

# Function to clear all items in the inventory
func clear_inventory() -> void:
	for index in range(inventory.items.size()):
		inventory.items[index] = null  # Clear each item
	inventory.updated.emit()  # Emit updated signal if needed
	
func open():
	visible = true
	isOpen = true

func close():
	visible = false
	isOpen = false
