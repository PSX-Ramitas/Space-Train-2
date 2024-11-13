extends Area2D
class_name PlayerHitbox

@onready var player_ss: Player = $".."

@onready var player_health_bar: TextureProgressBar = $"../HUD/HealthBar"

signal healthChanged(isHeal: bool, amount: int)
var is_alive
func _ready() -> void:
	is_alive = true
	var curHealth = PlayerData.health
	if curHealth == 0 or curHealth == null:
		PlayerData.health = PlayerData.maxHealth
	else:
		PlayerData.health = curHealth
	print("Player Health: ", PlayerData.health)
	player_health_bar.init_health(PlayerData.health)

func take_damage(damageAmount: int):
	if is_alive: 
		var new_health = max(0, PlayerData.health - damageAmount)
		player_ss.health = new_health
		player_health_bar._set_health(new_health)
		if new_health == 0:
			is_alive = false
			self.queue_free()
		# healthChanged.emit( false, damageAmount)

func heal_health(healAmount: int):
	if is_alive:
		var new_health = min(PlayerData.maxHealth, PlayerData.health + healAmount)
		player_ss.health = new_health
		player_health_bar._set_health(new_health)
	# healthChanged.emit( true, healAmount)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		heal_health(amount)
	else:
		take_damage(amount)
