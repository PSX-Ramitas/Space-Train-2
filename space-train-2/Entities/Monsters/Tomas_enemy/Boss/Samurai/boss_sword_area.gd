extends Area2D

var attack
var attacker
var can_attack = false
var playerInAttackRange
var playerInChaseRange
var attacks = ["attack", "attack_3", "attack_2"]

@onready var BossSwordArea = get_node(".")
@onready var animations = get_node("../AnimatedSprite2D")
@onready var PlayerHitBox = get_node("../../PlayerSS/PlayerHitbox")
@onready var Box = get_node("../../PlayerSS/FuckingDetectThisAreaGodotYouBitch")
@onready var timer =get_node("../Attack_Timer")

var attack_cooldown = .5
var attack_timer = 0.0



func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)
	timer.stop()

func _physics_process(delta: float) -> void:
	playerInAttackRange = BossSwordArea.overlaps_area(Box)	
	#print("playerInAttackRange? ", playerInAttackRange)
	inBossAttackRange(delta)

func inBossAttackRange(delta) -> void:
	if playerInAttackRange and attack_timer<=0:
			print("if statement before can_attack taken")
			can_attack=true
			timer.start()
			deal_damage()
	else:
		can_attack = false
		
	if attack_timer >0:
		attack_timer -= delta

func deal_damage():
	if can_attack:
		attacks.shuffle()
		var random_attack = attacks[0]
		var sprite_frames = animations.sprite_frames  # Get the SpriteFrames resource
		var frame_count = sprite_frames.get_frame_count(random_attack)  # Get the frame count for the current animation
		var animation_length = frame_count / animations.speed_scale  # Calculate the animation length
		animations.play(random_attack)
		print("Dealing damage to: ", PlayerHitBox, "\n" )
		PlayerHitBox.take_damage(attack)

		attack_timer= attack_cooldown


#func _on_area_entered(area: Area2D) -> void:
	#print ("area.name is ", area.name)
#	attacker = area
	#var player_hitbox = attacker.get_node_or_null("PlayerHitbox")
	#if attacker.name == "PlayerHitbox":
		#can_attack = true
		#print(attacker.name, " IN BOSS SWORD AREA, dealing damage")
		#_deal_damage()

#func _on_area_exited(area: Area2D) -> void:
#	if attacker.name =="FuckingDetectThisAreaGodotYouBitch":
#		can_attack = false
	#	$DamageTimer.stop()

#func _deal_damage() -> void:

#	print ("in deal_damage() , attacker : ", attacker.name)
#	print("can_attack? : ", can_attack, ", attacker?: ", attacker.name, "\n")
#	if can_attack and attacker.name =="PlayerHitbox":
#		attacks.shuffle()
#		var random_attack = attacks[0]
#		var player_hitbox = attacker.get_parent().get_node_or_null("PlayerHitbox")
#		print("player_hitbox = ",player_hitbox)
#		if player_hitbox:
#			print("player hitbox exists, gonna try to damage")
#			animations.play(random_attack)
#			player_hitbox.take_damage(attack)
#			print("Dealing damage to: ", attacker )
#			$DamageTimer.start()

#func _on_damage_timer_timeout() -> void:
#	inBossAttackRange()
	#deal_damage()
	#ass # Replace with function body.
