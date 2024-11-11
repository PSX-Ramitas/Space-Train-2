class_name Entity
extends CharacterBody2D

@export var maxHealth = 80
@export var health: int = 80
@export var movespeed: int
@export var attack: int


enum physStatus {none, crippled, bleed, vulnerable}
enum elemStatus {none, burned, shocked, frozen}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
