extends Node2D
@onready var detection_area: Area2D = $DetectionArea
@onready var warp_area: Area2D = $WarpArea
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var started: AudioStreamPlayer = $Sounds/Started
@onready var warping: AudioStreamPlayer = $Sounds/Warping

var portal_used: bool = false
signal warp
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_detection_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox and !portal_used:
		started.play()
		animations.play("Ready")


func _on_detection_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		animations.play("Idle")

func _on_warp_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox and !portal_used:
		portal_used = true
		warping.play()
		animations.play("Warp")
		portal_used = true
		warp.emit()


func _on_warp_area_exited(area: Area2D) -> void:
	pass
