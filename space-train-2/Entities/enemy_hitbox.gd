extends Area2D
class_name EnemyHitbox

@export var parent: Node
@onready var enemy_health_bar: TextureProgressBar = $"../HealthBar"


#if healing 20 hp - (true, 20)
#if dealing 10 hp - (false, 10)
signal healthChanged(isHeal : bool, amount : int) 

func _ready() -> void:
	if parent != null:
		enemy_health_bar.init_health(parent.Health)
		enemy_health_bar._set_health(parent.Health)
	

func take_damage(damageAmount: int):
	#if (grandparent.get_class() == "Player") or (grandparent.get_class() == "droidEnemy"):
	#	if grandparent.health > 0:
	#		parent.parent.health -= damageAmount
	#		health_bar._set_health(grandparent.health)
	var tempHealth
	if parent.health > 0:
		tempHealth = parent.Health - damageAmount
		parent.Health = max(tempHealth, 0)
		enemy_health_bar._set_health(parent.Health)
		
func heal_health(healAmount: int):
	var tempHealth
	if parent.Health < 100:
		tempHealth = parent.Health + healAmount
		parent.Health = min(tempHealth, 100)
		enemy_health_bar._set_health(parent.Health)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	#if (grandparent.get_class() == "Player") or (grandparent.get_class() == "droidEnemy"):
	#	if isHeal:
	#		grandparent.health += amount
	#	else:
	#		grandparent.health -= amount
	#	health_bar._set_health(grandparent.health)
	if isHeal:
		if parent!=null and parent.is_class("droidEnemy"):
			parent.Health += amount
			enemy_health_bar._set_health(parent.Health)
	else:
		if parent!=null and parent.is_class("droidEnemy"):
			parent.Health -= amount
			enemy_health_bar._set_health(parent.Health)
	

#func _on_danger_area_entered(area: Area2D) -> void:
#	healthChanged.emit(false, area.damage)
#	pass # Replace with function body.
