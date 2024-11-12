extends TextureProgressBar

@onready var timer: Timer = $Timer
@onready var damage_bar: TextureProgressBar = $DamageBar

var health := 0 : set = _set_health
var fill_tween: Tween = null
var damage_tween: Tween = null

func _ready():
	timer.stop()

func _set_health(new_health):
	var prev_health = health
	health = clamp(new_health, 0, max_value)

	value = health

	if health <= 0:
		_tween_health_and_damage(0)
		timer.start()
		return

	if health < prev_health:
		timer.start()
	else:
		_tween_health_and_damage(health)

func _tween_health_and_damage(health_value: float):
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

	fill_tween.tween_property(self, "value", health_value, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if health_value < health:
		damage_tween.tween_property(damage_bar, "value", health_value, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	else:
		damage_bar.value = health_value

func init_health(initial_health: int):
	health = initial_health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout():
	if damage_tween == null or not damage_tween.is_valid():
		damage_tween = create_tween()
	else:
		damage_tween.stop()
		damage_tween = create_tween()

	damage_tween.tween_property(damage_bar, "value", health, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if health <= 0:
		queue_free()
