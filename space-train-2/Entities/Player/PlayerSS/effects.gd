extends AnimatedSprite2D

func play_effect(name: String) -> void:
	self.visible = true
	self.play(name)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animation_finished() -> void:
	self.visible = false
