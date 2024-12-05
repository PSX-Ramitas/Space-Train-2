extends Node2D
@onready var scan_area: Area2D = $Scan/ScanArea
@onready var scan_anim: AnimatedSprite2D = $Scan/ScanAnim
@onready var scan_sound: AudioStreamPlayer = $Scan/Scan

@onready var shock_area: Area2D = $Shock/ShockArea
@onready var shock_anim: AnimatedSprite2D = $Shock/ShockAnim
@onready var shock_sound: AudioStreamPlayer = $Shock/Shock

@onready var cast_notif: AudioStreamPlayer = $CastNotif

func flip_sprites(flag: bool):
	if PlayerData.castType == "neutral":
		scan_anim.flip_h = flag
	elif PlayerData.castType == "electric":
		shock_anim.flip_h = flag

func flipped(flag:bool):
	if flag == true:
		scan_area.position = Vector2(62, 0)
		scan_anim.position = Vector2(62, 0)
	else:
		scan_area.position = Vector2(5, 0)
		scan_anim.position = Vector2(5, 0)
	flip_sprites(flag)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shock_area.monitoring = false
	scan_area.monitoring = false
	scan_anim.visible = false
	shock_anim.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerData.castType != "neutral":
		scan_area.monitoring = false
		scan_anim.visible = false
		
	if PlayerData.castType != "electric":
		shock_area.monitoring = false
		shock_anim.visible = false
		
	if Input.is_action_just_pressed("cast_spell"):
		if PlayerData.castType == "neutral":
			scan_anim.play()
			scan_sound.play()
			scan_area.monitoring = true
			scan_anim.visible = true
			await scan_anim.animation_finished
			scan_anim.visible = false
			scan_area.monitoring = false

		if PlayerData.castType == "electric":
			shock_anim.play()
			shock_sound.play()
			shock_anim.visible = true
			shock_area.monitoring = true
			await shock_anim.animation_finished
			shock_anim.visible = false
			shock_area.monitoring = false


func _on_scan_area_entered(area: Area2D) -> void:
	if area is EnemyHitbox:
		var victim = area.get_parent()
		print(victim.type)
		print("Area Scannable: ", area.is_scannable)
		if area.is_scannable and scan_anim.is_playing():
			scan_sound.stop()
			cast_notif.play()
			await scan_anim.animation_finished
			PlayerData.castType = victim.type
			area.take_damage(victim.health)
	print(PlayerData.castType)


func _on_shock_area_entered(area: Area2D) -> void:
	if (area is EnemyHitbox or area is VineHurtbox) and shock_anim.is_playing():
		area.take_damage(100)
	else:
		var victim = area.get_parent()
		for child in victim.get_children():
			if (child is Damageable):
				var direction_to_damageable = (area.global_position - get_parent().global_position)
				var direction_sign = sign(direction_to_damageable.x)
				
				if(direction_sign > 0):
					child.hit(100, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(100, Vector2.LEFT)
				else:
					child.hit(100, Vector2.ZERO)
	await shock_anim.animation_finished
	PlayerData.castType = "neutral"
