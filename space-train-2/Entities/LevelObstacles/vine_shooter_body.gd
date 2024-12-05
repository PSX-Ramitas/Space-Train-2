extends VineHurtbox


#signal healthChanged(isHeal : bool, amount : int) 
#signal health_changed(new_health: int)

func _ready():
	max_health = get_maxhealth()
	set_health(20)
	print("VineHurtbox: Health set to ", get_health())

	if get_healthbarNode():
		get_healthbarNode().init_health(max_health)
	emit_signal("health_changed", get_health())  # Emit initial health


func take_damage(damageAmount: int):
	
	var tempHealth
	if get_health() > 0:
		print(get_health())
		tempHealth = get_health() - damageAmount
		tempHealth = max(tempHealth, 0)
		set_health(tempHealth)
		get_healthbarNode()._set_health(get_health())
		emit_signal("health_changed", health)  # Notify health change
	if health <= 0:
		death_sound.play()
		monitoring = false
		monitorable = false
		emit_signal("health_changed", 0)
		print("VineHurtbox: Health is 0.")
		await get_tree().create_timer(0.7).timeout
		queue_free()
		
func heal_health(healAmount: int):
	var tempHealth
	if health <= max_health:
		tempHealth = health + healAmount
		health = min(tempHealth, max_health)
		health_bar._set_health(health)

func _on_health_changed(isHeal: bool, amount: int) -> void:
	if isHeal:
		health += amount
		health_bar._set_health(health)
	else:
		health -= amount
		health_bar._set_health(health)
	
