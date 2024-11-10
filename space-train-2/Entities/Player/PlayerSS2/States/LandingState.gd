extends State2

class_name LandingState

@export var landing_animation_name : String = "jump_end"
@export var ground_state : State2

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if(anim_name == landing_animation_name):
		next_state = ground_state
