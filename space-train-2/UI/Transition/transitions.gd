class_name TransitionScreen
extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

signal anim_finished
func play_transition(name: String) -> void:
	animation_player.play(name)
	color_rect.visible = true
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_finished.emit()
	color_rect.visible = false
