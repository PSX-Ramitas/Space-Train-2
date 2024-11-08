extends Node

class_name Damageable

@onready var parent: CharacterBody2D = $".."
@export var health : float:
	get:
		return health
	set(value):
		SignalBusMonster.emit_signal("on_health_changed", get_parent(), value - health)
		health = value

func _ready() -> void:
	health = parent.health
	
func hit(damage: int):
	health -= damage
	
	if(health <= 0):
		get_parent().queue_free()
