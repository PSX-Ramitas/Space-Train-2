extends TextureProgressBar

@onready var timer: Timer = $Timer
@onready var damage_bar: TextureProgressBar = $DamageBar
@onready var healing_bar: TextureProgressBar = $HealingBar

var health := 0 : set = _set_health
var fill_tween: Tween = null
var damage_tween: Tween = null

func _ready():
	timer.stop()

func _set_health(new_health):
	var prev_health = health
	health = clamp(new_health, 0, max_value)

	if health > prev_health:
		# Healing logic
		healing_bar.value = health
		timer.start()
		_tween_main_to_health(health)
	elif health < prev_health:
		# Damage logic
		value = health
		healing_bar.value = health
		timer.start()
		_tween_health_and_damage(health)
	else:
		value = health
		damage_bar.value = health
		healing_bar.value = health
	if health <= 0:
		timer.start()
		return

func _tween_main_to_health(health_value: float):
	# Tween main health bar to the new health value
	if fill_tween == null or not fill_tween.is_valid():
		fill_tween = create_tween()
	else:
		fill_tween.stop()
		fill_tween = create_tween()

	fill_tween.tween_property(self, "value", health_value, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _tween_health_and_damage(health_value: float):
	# Tween main health bar and damage bar for damage
	if fill_tween == null or not fill_tween.is_valid():
		fill_tween = create_tween()
	else:
		fill_tween.stop()
		fill_tween = create_tween()

	if damage_tween == null or not damage_tween.is_valid():
		damage_tween = create_tween()
	else:
		damage_tween.stop()
		damage_tween = create_tween()

	fill_tween.tween_property(self, "value", health_value, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	damage_tween.tween_property(damage_bar, "value", health_value, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func init_health(initial_health: int):
	# Set the maximum health
	max_value = initial_health
	
	# Initialize health to the current value or the initial value if uninitialized
	if health == 0:
		health = initial_health  # Set to full health if uninitialized

	# Initialize the main bar, damage bar, and healing bar to the current health
	value = initial_health
	damage_bar.max_value = initial_health
	damage_bar.value = initial_health
	healing_bar.max_value = initial_health
	healing_bar.value = initial_health


func _on_timer_timeout():
	if damage_tween == null or not damage_tween.is_valid():
		damage_tween = create_tween()
	else:
		damage_tween.stop()
		damage_tween = create_tween()

	damage_tween.tween_property(damage_bar, "value", health, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if health <= 0:
		queue_free()
