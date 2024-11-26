extends Area2D
class_name PlayerHitbox

@onready var player_ss: Player = $".."

@onready var player_health_bar: Control = $"../HUD/HealthBar"
@onready var damage_sound: AudioStreamPlayer = $"../Sounds/DamageSound"
@onready var heal_sound: AudioStreamPlayer = $"../Sounds/HealSound"
@onready var player_sprite = $"../AnimatedSprite2D"
@onready var inventory: Inventory = preload("res://inventory/playerinventory.tres")
signal healthChanged(isHeal: bool, amount: int)
var is_alive
var can_hurt

func _ready() -> void:
	is_alive = true
	can_hurt = true
	var curHealth = PlayerData.health
	if PlayerData.health == 0 or PlayerData.health == null:
		PlayerData.health = PlayerData.maxHealth
	else:
		PlayerData.health = curHealth
	print("Player Health: ", PlayerData.health)
	player_health_bar.start_health(PlayerData.maxHealth)
	player_health_bar.set_health(PlayerData.health)


func take_damage(damageAmount: int):
	if is_alive and can_hurt:
		damage_sound.play()
		var new_health = max(0, PlayerData.health - damageAmount)
		player_ss.health = new_health
		player_health_bar.set_health(new_health)
		if new_health == 0:
			self.PROCESS_MODE_DISABLED
			is_alive = false
		# healthChanged.emit( false, damageAmount)
		PlayerData.is_hurt = true



func heal_health(healAmount: int):
	if is_alive:
		heal_sound.play()
		var new_health = min(PlayerData.maxHealth, PlayerData.health + healAmount)
		player_ss.health = new_health
		player_health_bar.set_health(new_health)
	# healthChanged.emit( true, healAmount)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		heal_health(amount)
	else:
		take_damage(amount)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("collect") and count_items_in_inventory() < 1:
		area.collect(inventory)

func count_items_in_inventory() -> int:
	var count = 0
	for item in inventory.items:
		if item:
			count += 1
	return count
