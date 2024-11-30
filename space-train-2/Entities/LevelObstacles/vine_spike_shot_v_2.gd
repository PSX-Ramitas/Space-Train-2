extends Projectile
#extends Entity
#var SPEED = 150

#var dir : float 
#var spawnPos : Vector2 
#var spawnRot : float
#var dir = Vector2.ZERO
#var damage =6
#var hit =0; 
#var collision = move_and_slide(velocity)

func _ready():
	#Change the damage
	dir = Vector2.UP
	SPEED = 600
	global_position= spawnPos
	global_rotation= spawnRot
	$queueFreeTimer.start()
	
func _physics_process(delta): 
	velocity = dir * SPEED
	#Do not need it because my entire scene switches in vineshooteraction code
	#$Sprite2D.flip_v = dir.x > 0 
	position += dir * SPEED *delta 


func _on_queue_free_timer_timeout() -> void:
	queue_free()
	
