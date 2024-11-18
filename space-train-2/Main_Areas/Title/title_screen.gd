extends Node2D
@onready var transition: TransitionScreen = $CanvasLayer/TransitionAnim


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if LevelManager.worldClear == true:
		LevelManager.worldClear = false
		transition.play_transition("Split")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
