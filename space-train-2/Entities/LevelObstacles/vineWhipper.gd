extends VineFamilyClass
#STATES
@export var curr_state: vineWhipper_state
enum vineWhipper_state {ACTIVE, IDLE, DEATH}


#VARIABLES
@export var pause_frame: float = 0.6  # Set the desired frame (in seconds) to pause at
var is_player_inside: bool = false #true if player in detection area and will help with animation cutoffs
var is_attacked: bool = false #Will be used to detect if entity is being attack
var is_initialized: bool = false #true if the object is intialized
var hurtbox: VineHurtbox  # Reference to the VineHurtbox node
#GENERAL ANIMATION FUNCTIONS----------------------------------------------------------------------
func active_WhipperVines():
	if is_attacked: 
		
		await get_tree().create_timer(0.5).timeout
		curr_state = vineWhipper_state.ACTIVE
		$AnimatedVineWhipper.speed_scale = 2.2
		is_attacked = false
	else:
		curr_state = vineWhipper_state.ACTIVE
		$AnimatedVineWhipper.speed_scale = 2.2
	$AnimatedVineWhipper.play("active_attack")

func idle_WhipperVines():
	#if current animation NOT idle and is stull playing it will not idle
	#Fixes issue with animation CUTOFF
	if $AnimatedVineWhipper.current_animation != "Idle" && ! $AnimatedVineWhipper.is_playing():
		$AnimatedVineWhipper.play("Idle")
		curr_state = vineWhipper_state.IDLE

func death_WhipperVines():
	$AnimatedVineWhipper.play("Death")
	curr_state = vineWhipper_state.DEATH
#End of State animation function--------------------------------------------------------------------



#Signal functions--------------------------------------------------------------------------------- 
func _ready() -> void:
	# Find and connect to the VineHurtbox
	hurtbox = $".."
	if hurtbox:
		print("FOUND HURTBOX FILE")
		hurtbox.connect("Temphealth_changed", Callable(self, "_on_health_changed"))
		set_health(hurtbox.get_health())
	curr_state = vineWhipper_state.IDLE
	connect("area_entered", Callable(self,"_on_area_vines_entered"))
	$attackRadius.set_meta("is_vine_attack", true)
	is_attacked = false
	

func _process(_delta):
	if is_attacked:
		print("NOOOOO")
	if get_health() <= 0:
		curr_state = vineWhipper_state.DEATH
	match curr_state:
		vineWhipper_state.ACTIVE:
			active_WhipperVines()
		vineWhipper_state.IDLE:
			idle_WhipperVines()
		vineWhipper_state.DEATH:
			death_WhipperVines()
		

#detect player inside
func _on_detection_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		active_WhipperVines()
		is_player_inside = true #Player is inside
		print("Player entered Detection Area of VineFamilyClass:", area.name)

	
#detect player when exits
func _on_detection_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		print("Player exited Detection Area of VineFamilyClass:", area.name)
		is_player_inside = false #Player is now out of area

#check animation finishes
func _on_vine_whipper_animation_finished(anim_name: StringName) -> void:
	if anim_name == "active_attack":
		if is_player_inside:
			active_WhipperVines()
		else:
			idle_WhipperVines()
		
func _on_health_changed(new_health: int) -> void:
	print("VineWhipper: Health updated to ", new_health)
	if not is_initialized:
		set_health(new_health)
		is_initialized = true
		return
	#add a red damage affect
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	is_attacked = true
	$Sprite2D.modulate = Color.WHITE
	set_health(new_health)
