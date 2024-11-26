extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var item_notif: AudioStreamPlayer = $ItemNotif
@onready var inventory = preload("res://inventory/playerinventory.tres")

var index: int

func update(item: InventoryItem):
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
	else:
		item_notif.play()
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture

func clear() -> void:
		backgroundSprite.frame = 0
		itemSprite.visible = false
