extends Area2D
class_name VineFamilyClass
# Spikes common properties  
@export var vines_damage: int = 10  # Default damage dealt by trap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Automatically connect the `area_entered` signal to the base class function
	connect("area_entered", Callable(self,"_on_area_vines_entered"))

# Triggered when the player enters the vines' area
func _on_area_vines_entered(area: Area2D) -> void:
	if area is PlayerHitbox: # might need to check if parent is player if we want to only damage player and not monsters
#		# Assume the Player class has a `take_damage` function
		area.take_damage(vines_damage)
		print("Player HIT BY VineFamilyClass:", area.name)
