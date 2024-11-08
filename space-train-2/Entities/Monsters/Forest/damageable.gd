extends Node

class_name Damageable2

@onready var parent: CharacterBody2D = $".."
@export var health : float

func _ready() -> void:
	health = parent.health

func hit(damage: int):
	health -= damage
	print(health)
	
	if(health <= 0):
		get_parent().queue_free()
