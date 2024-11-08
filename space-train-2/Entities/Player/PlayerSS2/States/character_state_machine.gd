extends Node

class_name CharacterStateMachine

@export var character : CharacterBody2D
@export var current_state : State2
@export var animation_tree: AnimationTree

var states : Array[State2]

func _ready() -> void:
	for child in get_children():
		if child is State2:
			states.append(child)
			
			# Set states with what they need to function
			child.character = character
			child.playback = animation_tree["parameters/playback"]
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")

func _physics_process(delta: float) -> void:
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
	
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move

func switch_states(new_state : State2):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	
	current_state.on_enter()

func _input(event : InputEvent):
	current_state.state_input(event)
