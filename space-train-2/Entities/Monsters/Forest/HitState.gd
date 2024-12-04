extends State2

class_name HitState

@onready var monster: CharacterBody2D = $"../.."
@export var damageable : Damageable
@export var dead_state : State2
@export var dead_animation_node : String = "dead"
@export var knocback_speed : float = 100
@export var return_state : State2
@onready var timer: Timer = $Timer


@onready var item_scenes = [
	preload("res://Collectables/potion.tscn"),
	preload("res://Collectables/power.tscn"),
	preload("res://Collectables/harden.tscn"),
	preload("res://Collectables/speed.tscn")
]

var item_count = 0

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_enter():
	timer.start()

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		monster.velocity = knocback_speed * knockback_direction
		emit_signal("interrupt_state", self)
	else:
		if item_count < 1:
			drop_item()  # Call the drop_item function
			item_count+=1
		emit_signal("interrupt_state", dead_state)
		playback.travel(dead_animation_node)

func on_exit():
	monster.velocity = Vector2.ZERO

func _on_timer_timeout() -> void:
	next_state = return_state

func drop_item():
	# Set a drop chance (e.g., 30%)
	var drop_chance = 0.7  # 30% probability

	# Generate a random number between 0 and 1
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

			# Position the item relative to the monster's position
			item_instance.global_position = monster.global_position + Vector2(0, -20)
			print("Dropped item:", item_instance)
		else:
			print("No item scenes available for dropping.")
	else:
		print("No item dropped this time.")  # Debug message if no item is dropped
