extends State2

@export var attack_state: State2
@export var attack_animation : String = "run"

func on_enter():
	pass
	
func state_process(delta: float) -> void:
	if character.detection_right.is_colliding():
		character.direction = Vector2.RIGHT
		character.sprite_2d.flip_h = true
		attack()
	if character.detection_left.is_colliding():
		character.direction = Vector2.LEFT
		character.sprite_2d.flip_h = false
		attack()
	character.emit_signal("facing_direction_changed", character.sprite_2d.flip_h)

func attack():
	#character.speed = 2 * character.speed
	next_state = attack_state
	playback.travel(attack_animation)
