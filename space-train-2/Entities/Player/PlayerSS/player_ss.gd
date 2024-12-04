class_name Player
extends Entity

@export var active = true
@onready var animations = $AnimatedSprite2D
@onready var stateMachine = $FSM
@onready var sword = $PlayerSwordArea
@onready var PlayerHB: Control = $HUD/HealthBar
@onready var bullets: Node2D = $ProjectileSpawn
@onready var playerHitBox = $PlayerHitbox

@export var inventory: Inventory

@onready var originalAttack : int = attack 
@onready var originalSpeed : int = 325

signal attackChanged
signal damgeReduced

var queuedAttack = 1
var usedAirAttack = false
@export var dashCD = 2
@export var gunCD = 0.4
var usedDash = false
var usedGun = false
var attackResetTimer = 1.5
var fallFromPlatform = false #used to determine if coyote jump is allowed, as player can enter fall state from jump
var lbp = "r" #last button pressed, used to correct which way the player sprite faces

# variables to control player flashing white
var flash_duration = 1.1 # Total time to flash
var flash_interval = 0.1 # Time between flashes
var flash_timer = 0.0
var flashing = false

func start_flashing():
	flash_timer = flash_duration
	playerHitBox.monitoring = false
	playerHitBox.monitorable = false
	flashing = true
	
var player_hurt = false

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	maxHealth = PlayerData.maxHealth
	health = PlayerData.health
	movespeed = PlayerData.movespeed
	attack = PlayerData.attack
	if (attack > 10):
		attack = 10
	if (movespeed > 325):
		movespeed = 325
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
		if usedGun == true:
			gunCD -= delta
		if dashCD <= 0:
			print("reset dash")
			dashCD = 2
			usedDash = false
		if gunCD <= 0:
			print("GUN back")
			gunCD = 0.4
			usedGun = false
		if attackResetTimer < 0:
			#print("reset atttack")
			attackResetTimer = 1.5
			queuedAttack = 1
		else:
			attackResetTimer -= delta
		stateMachine.process_physics(delta)
		if PlayerData.is_hurt:
			start_flashing()
			PlayerData.is_hurt = false
		if flashing:
			flash_timer -= delta
			#print("iframe time remaining: ", flash_timer)
			var flash_phase = int((flash_duration - flash_timer) / flash_interval) % 2
			animations.material.set_shader_parameter("flash_intensity", flash_phase)
		# Stop flashing after the duration
		if flash_timer <= 0:
			flashing = false
			playerHitBox.monitoring = true
			playerHitBox.monitorable = true
			animations.material.set_shader_parameter("flash_intensity", 0.0)

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

func increase_speed(amount: int) -> void:
	print(" Original Speed: ", movespeed)
	if(movespeed < 625):
		movespeed += amount
	#print("Original Jump: ", velocity.y)
	#velocity.y = velocity.y + 20
	print(" New Speeed: ", movespeed)
	#print("New Jump: ", velocity.y)
	$Timer2.start()


func use_item(item: InventoryItem) -> void:
	item.use(self)


func _on_timer_timeout() -> void:
	attack = originalAttack
	attackChanged.emit(attack)
	print("Attack now: ", attack)


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	movespeed = originalSpeed
	#velocity.y = originalJump
	#speedChanged.emit(movespeed)
	print("speed now: ", movespeed)
