extends State2

class_name PlayerHitState

@onready var monster: CharacterBody2D = $"../.."
@export var damageable : Damageable
@export var dead_state : State2
@export var dead_animation_node : String = "dead"
@export var knocback_speed : float = 100
@export var return_state : State2
@onready var timer: Timer = $Timer

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_enter():
	timer.start()

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		monster.velocity = knocback_speed * knockback_direction
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state", dead_state)
		playback.travel(dead_animation_node)

func on_exit():
	monster.velocity = Vector2.ZERO

func _on_timer_timeout() -> void:
	next_state = return_state
