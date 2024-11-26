extends Resource
class_name Inventory

signal updated
signal use_item

@export var items: Array[InventoryItem]

func insert(item: InventoryItem):
	if count_items() >= 1:
		return
		
	for i in range(items.size()):
		if !items[i]:
			items[i] = item
			break
	updated.emit()

func count_items() -> int:
	var count = 0
	for item in items:
		if item:
			count += 1
	return count
	
func remove():
	items[0] = null  # Clear the slot
	updated.emit()

func removeitem(inventoryItem: InventoryItem):
	var index = items.find(inventoryItem)
	if index < 0: return
	
	remove_at_idex(index)

func remove_at_idex(index: int) -> void:
	#items[index] = InventoryItem.new()
	items[0] = null
	updated.emit()


func use_item_at_index(index: int) -> void:
	if index < 0 || index >= items.size() || !items[index]: return
	use_item.emit(items[0])
	remove_at_idex(index)
	
	
