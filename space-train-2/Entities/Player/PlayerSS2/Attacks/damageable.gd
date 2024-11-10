extends Node

class_name Damageable

@export var parent: CharacterBody2D
@onready var timer: Timer = $Timer

signal on_hit(node : Node, damage_take : int, knockback_direction : Vector2)

@export var health : float:
	get:
		return health
	set(value):
		SignalBusMonster.emit_signal("on_health_changed", get_parent(), value - health)
		health = value

@export var dead_animation_name : String = "dead"

func _ready() -> void:
	health = parent.health

func hit(damage: int, knockback_direction : Vector2):
	print(health)
	if(damage > 0):
		health -= damage
		parent.health = health
	elif(damage < 0 and parent.maxHealth > parent.health):
		health -= damage
		parent.health = health
		if(parent.health > parent.maxHealth):
			parent.health = parent.maxHealth
	
	emit_signal("on_hit", get_parent(), damage, knockback_direction)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if(anim_name == dead_animation_name):
		if parent.name == "PlayerSs2":
			print("YOU DIED TO A MONSTER!")
			Engine.time_scale = 0.5
			parent.get_node("CollisionShape2D").queue_free()
			timer.start()
		else:
			get_parent().queue_free()


func _on_timer_timeout() -> void:
	print("YOU DIED TO A MONSTER!")
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
