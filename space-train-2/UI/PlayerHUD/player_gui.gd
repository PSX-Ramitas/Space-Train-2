extends Control

@onready var health_bar: TextureProgressBar = $HealthBar



func start_health(value):
	health_bar.init_health(value)

func set_health(value):
	health_bar._set_health(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health_bar.value == 0:
		queue_free()
	else:
		queue_redraw()
