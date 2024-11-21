extends Control
@onready var label: Label = $Label



func _on_sign_zone_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		label.visible = true

func _on_sign_zone_area_exited(area: Area2D) -> void:
	label.visible = false
