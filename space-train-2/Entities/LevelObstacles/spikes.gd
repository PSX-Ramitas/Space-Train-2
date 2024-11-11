extends SpikesClass
@export var parent: Node
@onready var health_bar: TextureProgressBar = $"../HealthBar"


func _on_area_spikes_entered(area: Area2D) -> void:
	if area.get_parent() is Player and area is PlayerHitbox:
		area.take_damage(spike_damage)
		print(area.name)
