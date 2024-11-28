extends Node


var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.0
var knockback_timer = 0.0
var is_knocked_back = false

const KNOCKBACK_SPEED = 500.0

func apply_knockback(direction: Vector2, duration: float):
	knockback_velocity = direction.normalized() * KNOCKBACK_SPEED
	knockback_duration = duration
	knockback_timer = 0.0
	is_knocked_back = true

func process_knockback(delta):
	if is_knocked_back:
		print("we knockbacking yall")
		knockback_timer += delta
		if knockback_timer < knockback_duration:
			return knockback_velocity
		else:
			is_knocked_back = false
			knockback_velocity = Vector2.ZERO
	return Vector2.ZERO
