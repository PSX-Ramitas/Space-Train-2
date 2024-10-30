extends Area2D

@export var parent: Node
@onready var health_bar: TextureProgressBar = $"../HealthBar"


#if healing 20 hp - (true, 20)
#if dealing 10 hp - (false, 10)
signal healthChanged(isHeal : bool, amount : int) 

func _ready() -> void:
	health_bar.init_health(parent.health)
	health_bar._set_health(parent.health)

func take_damage(damageAmount: int):
	if parent.health > 0:
		parent.health -= damageAmount
		health_bar._set_health(parent.health)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		parent.health += amount
	else:
		parent.health -= amount
	health_bar._set_health(parent.health)

#func _on_danger_area_entered(area: Area2D) -> void:
#	healthChanged.emit(false, area.damage)
#	pass # Replace with function body.
