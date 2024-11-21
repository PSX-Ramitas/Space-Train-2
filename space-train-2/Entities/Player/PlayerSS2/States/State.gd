extends Node

class_name State2

@export var can_move : bool = true
@onready var death_sound: AudioStreamPlayer = $"../../Sounds/DeathSound"

var character : CharacterBody2D
var next_state : State2
var playback :AnimationNodeStateMachinePlayback

signal interrupt_state(new_state : State2)

func state_process(delta):
	pass

# Default if not overwritten by a child class
func state_input(event : InputEvent):
	pass

func on_enter():
	death_sound.play()

func on_exit():
	pass
