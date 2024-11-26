extends CharacterBody2D
@onready var pause_menu: Control = $HUD/PauseMenu

# Define movement speed
var speed = 350
@onready var animations = $Sprite
var lbp = "left"
# Function to handle movement
func _ready():
	var button = pause_menu.find_child("Forfeit")
	button.visible = false
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	# Get input from arrow keys or WASD
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Normalize the vector to ensure uniform movement speed in all directions
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
	
	# Move the character using the input vector and speed
	velocity = input_vector * speed
		
	if velocity == Vector2.ZERO:
		animations.play("Idle")
	else:
		animations.play("Run")

	#ensure that the player is facing the correct direction after inputs are gone
	if(velocity.x < 0):
		lbp = "l"
	elif(velocity.x > 0):
		lbp = "r"
	if(lbp == "l"):
		animations.flip_h = true
	else:
		animations.flip_h = false
	# Move and slide to handle collisions
	move_and_slide()
