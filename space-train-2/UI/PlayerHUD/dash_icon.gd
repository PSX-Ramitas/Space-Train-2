extends Control
@onready var cooldownPlayer: AnimationPlayer = $AnimationPlayer
@onready var background: Sprite2D = $NinePatchRect/GridContainer/background
@onready var recharge_notif: AudioStreamPlayer = $RechargeNotif


func play_cooldown():
	background.visible = true
	cooldownPlayer.play("Cooldown")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_animation_finished(anim_name: StringName) -> void:
	background.visible = false
	recharge_notif.play()
