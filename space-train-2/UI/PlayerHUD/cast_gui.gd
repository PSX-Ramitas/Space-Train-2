extends Control
@onready var cooldownPlayer: AnimationPlayer = $AnimationPlayer
@onready var scan_sprite: Sprite2D = $NinePatchRect/GridContainer/CenterContainer/Panel/ScanSprite
@onready var shock_sprite: Sprite2D = $NinePatchRect/GridContainer/CenterContainer/Panel/ShockSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerData.castType == "neutral":
		scan_sprite.visible = true
		shock_sprite.visible = false
	elif PlayerData.castType == "electric":
		shock_sprite.visible = true
		scan_sprite.visible = false
