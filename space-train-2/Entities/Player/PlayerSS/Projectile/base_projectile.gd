extends CharacterBody2D

const SPEED = 300.0
@export var damage = 3.5

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_bullet_area_area_entered(area: Area2D) -> void:
	var attacker = area.get_parent()
	print(attacker.name, "IN SWORD AREA")
	if attacker is SpikesClass:
		print("YES SPIKES",area.name)
		return
	elif attacker is not Player and (area is EnemyHitbox or area is VineHurtbox):
			area.take_damage(damage)
			print("area.name that took damage: ", area.name)
			queue_free()
	else:
		for child in attacker.get_children():
			if (child is Damageable):
				var direction_to_damageable = (area.global_position)
				var direction_sign = sign(direction_to_damageable.x)
				if(direction_sign > 0):
					child.hit(damage, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(damage, Vector2.LEFT)
				else:
					child.hit(damage, Vector2.ZERO)
				queue_free()


func _on_timer_timeout() -> void:
	queue_free()
