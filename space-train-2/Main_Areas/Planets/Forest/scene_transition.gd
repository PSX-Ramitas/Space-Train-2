extends Area2D

@export var transitioner : Transitioner

func _on_area_entered(area: Area2D) -> void:
	print(area)
	transitioner.set_next_animation(true)


func _on_body_entered(body: Node2D) -> void:
	print(body)
	transitioner.set_next_animation(true)
