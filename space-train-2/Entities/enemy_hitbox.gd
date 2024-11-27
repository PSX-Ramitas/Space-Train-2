extends Area2D
class_name EnemyHitbox

@onready var enemy: = $".."
@onready var enemy_health_bar: TextureProgressBar = $"../HealthBar"
@onready var death_sound: AudioStreamPlayer = $"../Sounds/DeathSound"

var is_scannable
var has_been_scanned

# Preload item scenes for random drops
@onready var item_scenes = [
	preload("res://Collectables/potion.tscn"),
	preload("res://Collectables/power.tscn")
]

var bot

signal healthChanged(isHeal: bool, amount: int)

func _ready() -> void:
	is_scannable = false
	has_been_scanned = false
	var initial_health = enemy.get_health()
	print("Enemy Health: ", enemy.health)
	enemy_health_bar.init_health(initial_health)
	enemy_health_bar._set_health(initial_health)

# Enemy takes damage
func take_damage(damageAmount: int):
	var tempHealth
	if enemy.health > 0:
		tempHealth = enemy.health - damageAmount
		enemy.health = max(tempHealth, 0)
		enemy_health_bar._set_health(enemy.health)
	# Check if enemy has died
	if enemy.health <= 0:
		death_sound.play()
		drop_item()  # Call the drop_item function
		await get_tree().create_timer(0.5).timeout
		queue_free()  # Remove enemy from the scene

# Heal enemy health
func heal_health(healAmount: int):
	var tempHealth
	if enemy.health <= enemy.maxHealth:
		tempHealth = enemy.health + healAmount
		enemy.health = min(tempHealth, enemy.maxHealth)
		enemy_health_bar._set_health(enemy.health)

# Handle health change signal
func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		enemy.health += amount
		enemy_health_bar._set_health(enemy.health)
	else:
		enemy.health -= amount
		enemy_health_bar._set_health(enemy.health)

# Function to handle random item drops

func drop_item():
	# Set a drop chance (e.g., 30%)
	var drop_chance = 0.5  # 30% probability of dropping an item

	# Generate a random float between 0 and 1
	if randf() <= drop_chance:
		if item_scenes.size() > 0:
			var random_index = randi() % item_scenes.size()
			var item_scene = item_scenes[random_index]  

			var item_instance = item_scene.instantiate()
			var root_node = get_tree().get_current_scene()
			if root_node:
				root_node.add_child(item_instance) 
			else:
				print("Error: Could not find the current scene root!")
				return

			# Adjust the drop position
			if botWheel:
				item_instance.global_position = global_position + Vector2(0, -50) 
			else:
				item_instance.global_position = global_position

			print("Dropped item:", item_instance)
	else:
		print("No item dropped this time.")  # Debug message for no drop
		
func _process(delta: float) -> void:
	if enemy.get_health() < enemy.maxHealth * 0.25 and !has_been_scanned:
		is_scannable = true
	else:
		is_scannable = false
