extends Area2D

var attack
var attacker
var can_attack = false
@onready var animations = get_node("../AnimatedSprite2D")
var attacks = ["attack", "attack_3", "attack_2"]
#@onready var timer =$DamageTimer
func _ready() -> void:
	var parent_node = get_parent()  # Dynamically get the parent node
	if parent_node:
		attack = parent_node.attack
		print(str(parent_node).split(":")[0], " Attack: ", attack)


func _on_area_entered(area: Area2D) -> void:
	can_attack = true
	attacker = area.get_parent()
	if attacker is Player and area is PlayerHitbox:
		print(attacker.name, " IN BOSS SWORD AREA, dealing damage")
		_deal_damage()
		$DamageTimer.start()

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player and area is PlayerHitbox:
		can_attack = false
		$DamageTimer.stop()

func _deal_damage() -> void:
	if can_attack and attacker:
		var random_attack = attacks[0]
		attacks.shuffle()
		animations.play(random_attack)
		var player_hitbox = attacker.get_node_or_null("PlayerHitbox")
		if player_hitbox:
			player_hitbox.take_damage(attack)
			print("Dealing damage to: ", attacker.name)

func _on_damage_timer_timeout() -> void:
	_deal_damage()
	pass # Replace with function body.
