extends Area2D
class_name EnemyHitbox

@onready var enemy: droidEnemy = $".."
@onready var enemy_health_bar: TextureProgressBar = $"../HealthBar"


#if healing 20 hp - (true, 20)
#if dealing 10 hp - (false, 10)
signal healthChanged(isHeal : bool, amount : int) 
var is_alive: bool
func _ready() -> void:
	is_alive = true
	var initial_health = enemy.get_health()
	print("Enemy Health: ", enemy.health)
	enemy_health_bar.init_health(initial_health)
	enemy_health_bar._set_health(initial_health)

func take_damage(damageAmount: int):
	#if (grandparent.get_class() == "Player") or (grandparent.get_class() == "droidEnemy"):
	#	if grandparent.health > 0:
	#		parent.parent.health -= damageAmount
	#		health_bar._set_health(grandparent.health)
	if is_alive:
		var tempHealth
		if enemy.health > 0:
			tempHealth = enemy.health - damageAmount
			enemy.health = max(tempHealth, 0)
			enemy_health_bar._set_health(enemy.health)
			if enemy.health == 0:
				is_alive = false
				queue_free()
		
func heal_health(healAmount: int):
	if is_alive:
		var tempHealth
		if enemy.health <= enemy.maxHealth:
			tempHealth = enemy.health + healAmount
			enemy.health = min(tempHealth, enemy.maxHealth)
			enemy_health_bar._set_health(enemy.health)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	#if (grandparent.get_class() == "Player") or (grandparent.get_class() == "droidEnemy"):
	#	if isHeal:
	#		grandparent.health += amount
	#	else:
	#		grandparent.health -= amount
	#	health_bar._set_health(grandparent.health)
	if isHeal:
		enemy.health += amount
		enemy_health_bar._set_health(enemy.health)
	else:
		enemy.health -= amount
		enemy_health_bar._set_health(enemy.health)
	

#func _on_danger_area_entered(area: Area2D) -> void:
#	healthChanged.emit(false, area.damage)
#	pass # Replace with function body.
