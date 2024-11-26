extends Area2D
class_name VineFamilyClass

# Vine common properties  
@export var vines_damage: int = 9  # Default damage dealt by trap
@export var max_health: int = 60
@export var health: int
@onready var health_bar = $HealthBar  # Reference to the health bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	#Automatically connect the `area_entered` signal to the base class function

# Triggered when the player enters the vines' area
func _on_area_vines_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
#		# Assume the Player class has a `take_damage` function
		area.take_damage(vines_damage)
		print("Player HIT BY VineFamilyClass:", area.name)
		
		
func get_health():
	return health
	
func set_health(new_health: int) -> void:	
	health = new_health
func get_maxhealth():
	return max_health
func get_healthbarNode():
	return health_bar
