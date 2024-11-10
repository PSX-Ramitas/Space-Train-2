extends Area2D

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_area_entered(area: Area2D) -> void:
	print("YOU ARE DEAD!")
	Engine.time_scale = 0.5
	area.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_body_entered(body: Node2D) -> void:
	print(str(body.name) + " DIED TO AN UNMOVABLE OBJECT!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
