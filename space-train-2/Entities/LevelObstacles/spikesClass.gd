class_name SpikesClass
extends Area2D

# Spikes common properties  
@export var spike_damage: int = 3  # Default damage dealt by trap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Automatically connect the `area_entered` signal to the base class function
	connect("area_entered", Callable(self,"_on_area_spikes_entered"))

# Triggered when the player enters the spikes' area
func _on_area_spikes_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		# Assume the Player class has a `take_damage` function
		#area.take_damage(spike_damage)
		print("Player entered Classspikes:", area.name)
