extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if (child is Damageable):
			child.hit(-40, Vector2.ZERO)
			print("I'm a heart")
			animation_player.play("pickup")
