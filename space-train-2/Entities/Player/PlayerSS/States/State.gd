class_name State
extends Node


@export var animationName: String
var moveSpeed: float
var jumpVelocity: float = -725
var dashVelocity: float = -1000
var gravity: int = 2500

# Hold a reference to the parent so that it can be controlled by the state
var parent: CharacterBody2D
var animations: AnimatedSprite2D

func enter() -> void:
	moveSpeed = parent.movespeed
	animations.play(animationName)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
