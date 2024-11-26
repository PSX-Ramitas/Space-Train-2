extends CharacterBody2D
class_name Projectile
#extends Entity
var SPEED = 150
@onready var bullet_area: Area2D = $BulletArea

#var dir : float 
var spawnPos : Vector2 
var spawnRot : float
var dir = Vector2.ZERO
var damage = 2
var hit =0; 
#var collision = move_and_slide(velocity)

func _ready():
	global_position= spawnPos
	global_rotation= spawnRot
	$queueFreeTimer.start()
	
func _physics_process(delta): 
	velocity = dir * SPEED
	$Sprite2D.flip_h = dir.x > 0 
	position += dir * SPEED *delta 


func _on_queue_free_timer_timeout() -> void:
	queue_free()
	
