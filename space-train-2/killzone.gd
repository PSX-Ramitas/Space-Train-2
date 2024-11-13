extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox or area is EnemyHitbox:
		area.take_damage(9999999999)
	if area.get_parent().get_child(4) == Damageable:
		var victim = area.get_parent().get_child(4)
		victim.hit(9999999, Vector2(0,0))
