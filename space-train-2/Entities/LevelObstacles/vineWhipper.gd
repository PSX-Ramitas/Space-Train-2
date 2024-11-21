extends VineFamilyClass

#STATES
@export var curr_state: vineWhipper_state
enum vineWhipper_state {ACTIVE, IDLE, DEATH}

#VARIABLES
@export var pause_frame: float = 0.6  # Set the desired frame (in seconds) to pause at
var is_player_inside: bool = false #true if player in detection area and will help with animation cutoffs

#GENERAL ANIMATION FUNCTIONS----------------------------------------------------------------------
func active_WhipperVines():
	curr_state = vineWhipper_state.ACTIVE
	$AnimatedVineWhipper.play("active_attack")

func idle_WhipperVines():
	#if current animation NOT idle and is stull playing it will not idle
	#Fixes issue with animation CUTOFF
	if $AnimatedVineWhipper.current_animation != "Idle" && ! $AnimatedVineWhipper.is_playing():
		$AnimatedVineWhipper.play("Idle")
		curr_state = vineWhipper_state.IDLE


func _process(_delta):
	match curr_state:
		vineWhipper_state.ACTIVE:
			active_WhipperVines()
		vineWhipper_state.IDLE:
			idle_WhipperVines()
		


#Signal functions--------------------------------------------------------------------------------- 

func _ready() -> void:
	curr_state = vineWhipper_state.IDLE

#detect player inside
func _on_detection_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		active_WhipperVines()
		is_player_inside = true #Player is inside
		print("Player entered Detection Area of VineFamilyClass:", area.name)

#damage method inherited updated
func _on_vine_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox: # might need to check if parent is player if we want to only damage player and not monsters
#		# Assume the Player class has a `take_damage` function
		area.take_damage(vines_damage)
		print("Player HIT BY VineFamilyClass:", area.name)
	
#detect player when exits
func _on_detection_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		print("Player exited Detection Area of VineFamilyClass:", area.name)
		is_player_inside = false #Player is now out of area

#check animation finishes
func _on_vine_whipper_animation_finished(anim_name: StringName) -> void:
	if anim_name == "active_attack":
		if is_player_inside:
			curr_state = vineWhipper_state.ACTIVE
		else:
			idle_WhipperVines()
		
		
