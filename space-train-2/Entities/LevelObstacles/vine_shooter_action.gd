extends VineFamilyClass
#STATES
@export var curr_state: vineShooter_state
enum vineShooter_state {ACTIVE, ACTIVE_AIR, IDLE, DEATH, FINALSTANCE}

#VARIABLES
var vine_shooter # used for a reference origin of detection area
var is_player_inside: bool = false #true if player in detection area and will help with animation cutoffs
var is_attacked: bool = false #Will be used to detect if entity is being attack
var is_initialized: bool = false #true if the object is intialized
var hurtbox: VineHurtbox  # Reference to the VineHurtbox node
var direction = Vector2.RIGHT
var player

#Projectile variables
@onready var projectile
var windupTimer = .6667
var can_shoot = true
var projectile_dir: Vector2
var gun_offset = Vector2(-10,14)
#General Animation Functions---------------------------------------------------------------------
func active_ShooterVines():
	
	curr_state = vineShooter_state.ACTIVE
	
	$AnimatedVineShooter.speed_scale = 1.2
	$AnimatedVineShooter.play("Attack")
	
func active_upattack_ShooterVines():
	curr_state = vineShooter_state.ACTIVE_AIR
	$AnimatedVineShooter.speed_scale = 1.2
	$AnimatedVineShooter.play("Attack_Air")

func idle_ShooterVines():
	#if current animation NOT idle and is stull playing it will not idle
	#Fixes issue with animation CUTOFF
	if $AnimatedVineShooter.current_animation != "Idle" && ! $AnimatedVineShooter.is_playing():
		$AnimatedVineShooter.speed_scale = 0.6
		$AnimatedVineShooter.play("Idle")
		curr_state = vineShooter_state.IDLE

func death_ShooterVines():
	$AnimatedVineShooter.play("Death")
	curr_state = vineShooter_state.DEATH


func _sprite_orientation(direction):
	#if the player is on the right side
	if direction.x > 0:
		#use the parent node to flip instead of the animationplayer (VINESHOOTERACTION)(-1 to flip from origin orientation)
		$".".scale.x = -1
		gun_offset.y = 14
	else:#if player is on the left side
		$".".scale.x = 1
		gun_offset.y = -14
		
func shoot():
	if can_shoot: 
		var instance = projectile.instantiate()
		instance.spawnPos= global_position + gun_offset.rotated(global_rotation)
		instance.spawnRot = global_rotation
		$"..".add_child(instance)
		if $".".scale.x == -1:
			instance.dir = Vector2.RIGHT  
		else:
			instance.dir = Vector2.LEFT  # Normal direction to the right
		can_shoot=false
		$ShootingTimer.start()






#Signal Functions---------------------------------------------------------------------------------
func _ready() -> void:
	projectile = load("res://Entities/LevelObstacles/VineSpikeShot.tscn")
	#shoot()
	vine_shooter = $"..".global_position
	# Find and connect to the VineHurtbox
	hurtbox = $".."
	if hurtbox:
		print("FOUND HURTBOX FILE")
		hurtbox.connect("health_changed", Callable(self, "_on_health_changed"))
		set_health(hurtbox.get_health())
	curr_state = vineShooter_state.IDLE
	connect("area_entered", Callable(self,"_on_area_vines_entered"))
	is_attacked = false
	is_player_inside = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_health() <= 0:
		curr_state = vineShooter_state.DEATH
	match curr_state:
		vineShooter_state.ACTIVE:
			active_ShooterVines()
		vineShooter_state.IDLE:
			idle_ShooterVines()
		vineShooter_state.DEATH:
			death_ShooterVines()
		




func _on_vine_shooter_body_health_changed(new_health: int) -> void:
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


func _on_floor_detection_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		_sprite_orientation(direction)
		print("The Direction of the player is at:", direction)
		active_ShooterVines()
		is_player_inside = true #Player is inside
		print("Player entered Detection Area of VineFamilyClass:", area.name)


func _on_floor_detection_area_exited(area: Area2D) -> void:
	if area is PlayerHitbox:
		print("Player exited Detection Area of VineFamilyClass:", area.name)
		is_player_inside = false #Player is now out of area


func _on_animated_vine_shooter_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		if is_player_inside:
			active_ShooterVines()
		else:
			idle_ShooterVines()  # Ensure the idle function is called here
	elif anim_name == "Attack_Air":
		if is_player_inside:
			curr_state = vineShooter_state.ACTIVE_AIR
		else:
			idle_ShooterVines()

#will look for character body
func _on_floor_detection_CHAR_BODY_entered(body: Node2D) -> void:
	if body is Player:
		player = body #store a reference of the player
		
		#position of vine
		var tempdir = position.direction_to(vine_shooter)*125#to make value bigger and less prone to floating error
		#position of player
		direction =  position.direction_to(player.global_position)*125#to make value bigger and less prone to floating error
		#see which side of the vines player lies on
		direction.x = direction.x - tempdir.x
		#set it equal to one bc all we care about is the sign
		direction.x = abs(direction.x) /direction.x # flip direction when turning
		print("final value of direction after abs division:", direction.x)


func _on_shooting_timer_timeout() -> void:
	can_shoot =true
