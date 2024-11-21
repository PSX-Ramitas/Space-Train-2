extends State

var timer = 1.75
var animTimer = 0.7
var transitionScreen
func enter() -> void:
	PlayerData.is_dead = true
	transitionScreen = parent.find_child("DeathTransition")
	var sfx = parent.find_child("Death")
	sfx.play()
	parent.sword.monitoring = false
	print("you died, loser")
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	timer -= delta
	if timer <= 0:
		transitionScreen.play_transition("FadeOut")
		animTimer -= delta
		if animTimer <= 0:
			get_tree().change_scene_to_file("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")
			LevelManager.resetLevelState()
	return null
