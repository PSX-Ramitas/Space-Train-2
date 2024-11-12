extends Area2D
class_name PlayerHitbox

@onready var player_ss: Player = $".."

@onready var player_health_bar: TextureProgressBar = $"../HUD/HealthBar"

signal healthChanged(isHeal: bool, amount: int)

func _ready() -> void:
	var initial_health = player_ss.get_health()
	print("Player Health: ", player_ss.health)
	player_health_bar.init_health(initial_health)
	player_health_bar._set_health(initial_health)

func take_damage(damageAmount: int):
	if player_health_bar != null: # added this so game wouldnt crash when player dies -tg
		var new_health = max(0, player_ss.get_health() - damageAmount)
		player_ss.health = new_health
		player_health_bar._set_health(new_health)
		# healthChanged.emit( false, damageAmount)

func heal_health(healAmount: int):
	var new_health = min(player_ss.maxHealth, player_ss.get_health() + healAmount)
	player_ss.health = new_health
	player_health_bar._set_health(new_health)
	# healthChanged.emit( true, healAmount)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		heal_health(amount)
	else:
		take_damage(amount)
