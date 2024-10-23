extends Node

@export var startState: State

var currState: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default startState.
func init(parent: CharacterBody2D, animations: AnimatedSprite2D) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations
	# Initialize to the default state
	change_state(startState)

# Change to the new state by first calling any exit logic on the current state.
func change_state(newState: State) -> void:
	if currState:
		currState.exit()
	#print("new state: " + str(currState))
	currState = newState
	currState.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var newState = currState.process_physics(delta)
	if newState:
		change_state(newState)

func process_input(event: InputEvent) -> void:
	var newState = currState.process_input(event)
	if newState:
		change_state(newState)

func process_frame(delta: float) -> void:
	var newState = currState.process_frame(delta)
	if newState:
		change_state(newState)
