extends Node

var movespeed = 325
var maxHealth = 45
var health = 45
var initHealth = 145 #For reinitializing in the event of stat upgrades
var attack = 10
var pausable: bool = false #May need to be removed
var is_dead: bool = false
var forfeited: bool = false
var is_hurt: bool = false
var castType: String = "neutral"
#can also put currency and abilities in here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
