extends Label

@export var state_machine : CharacterStateMachine
@export var player_ss_2: Player2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "State: " + state_machine.current_state.name
