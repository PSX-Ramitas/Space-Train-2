extends State

var timer = 1.75
func enter() -> void:
	parent.sword.monitoring = false
	print("you died, loser")
	super() #call the enter function of the class we inherit from

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	timer -= delta
	if timer <= 0:
		get_tree().change_scene_to_file("res://ui/temp_level_select.tscn")
	return null
