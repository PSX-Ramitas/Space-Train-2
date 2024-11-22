extends Area2D

@onready var loot_tracker: Node = $lootTracker

func _on_body_entered(body: Node) -> void:
	if body.name == "PlayerSS":  
		var loot_tracker = body.get_node("lootTracker")
		if loot_tracker != null:
			loot_tracker.add_point()
			queue_free()
