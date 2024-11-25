class_name Player
extends Entity

@export var active = true
@onready var animations = $AnimatedSprite2D
@onready var stateMachine = $FSM
@onready var sword = $PlayerSwordArea
@onready var playerHB: TextureProgressBar = $HUD/HealthBar
@onready var bullets: Node2D = $ProjectileSpawn

@export var inventory: Inventory

@onready var originalAttack : int = attack 

signal attackChanged
signal damgeReduced

var queuedAttack = 1
var usedAirAttack = false
var dashCD = 2
var usedDash = false
var attackResetTimer = 1.5
var fallFromPlatform = false #used to determine if coyote jump is allowed, as player can enter fall state from jump
var lbp = "r" #last button pressed, used to correct which way the player sprite faces

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	maxHealth = PlayerData.maxHealth
	health = PlayerData.health
	movespeed = PlayerData.movespeed
	attack = PlayerData.attack
	stateMachine.init(self, animations)
	inventory.use_item.connect(use_item)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)

func get_health():
	return PlayerData.health

func _physics_process(delta: float) -> void:
	if active:
		updatePlayerData()
		if usedDash == true:
			dashCD -= delta
		if dashCD <= 0:
			print("reset dash")
			dashCD = 2
			usedDash = false
		if attackResetTimer < 0:
			#print("reset atttack")
			attackResetTimer = 1.5
			queuedAttack = 1
		else:
			attackResetTimer -= delta
		stateMachine.process_physics(delta)

func updatePlayerData():
	if maxHealth != PlayerData.maxHealth:
		PlayerData.maxHealth = maxHealth
	if health != PlayerData.health:
		PlayerData.health = health
	if movespeed != PlayerData.movespeed:
		PlayerData.movespeed = movespeed
	if attack != PlayerData.attack:
		PlayerData.attack = attack 

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)
	if active:
		self.visible = true
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, true)
	else:
		self.visible = false
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, false)

func increase_attack(amount: int) -> void:
	print(" Original Attack: ", attack)
	#print(attack)
	attack += amount
	
	attackChanged.emit(attack)
	#print(attack)
	print(" New Attack: ", attack)
	$Timer.start()


func use_item(item: InventoryItem) -> void:
	item.use(self)


func _on_timer_timeout() -> void:
	attack = originalAttack
	attackChanged.emit(attack)
	print("Attack now: ", attack)


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
