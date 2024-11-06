class_name Player
extends Entity

@onready var animations = $AnimatedSprite2D
@onready var stateMachine = $FSM
@onready var sword = $PlayerSwordArea
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
	stateMachine.init(self, animations)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)

func _get_health():
	return health

func _physics_process(delta: float) -> void:
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

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)
	pass # Replace with function body.
