extends Area2D
class_name PlayerHitbox

@export var parent: Node  # This should be set to the player node in the editor or script
@onready var player_health_bar: TextureProgressBar = $"../HUD/HealthBar"

signal healthChanged(isHeal: bool, amount: int)

func _ready() -> void:
	# Ensure that `parent` is the player node and has a `Health` property
	if parent and parent.has_method("get_health"):
		var initial_health = parent.get_health()
		player_health_bar.init_health(initial_health)
		player_health_bar._set_health(initial_health)

func take_damage(damageAmount: int):
	if parent and parent.has_method("get_health"):
		var new_health = max(0, parent.get_health() - damageAmount)
		parent.set_health(new_health)
		player_health_bar._set_health(new_health)
		emit_signal("healthChanged", false, damageAmount)

func heal_health(healAmount: int):
	if parent and parent.has_method("get_health"):
		var new_health = min(parent.get_max_health(), parent.get_health() + healAmount)
		parent.set_health(new_health)
		player_health_bar._set_health(new_health)
		emit_signal("healthChanged", true, healAmount)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		heal_health(amount)
	else:
		take_damage(amount)
