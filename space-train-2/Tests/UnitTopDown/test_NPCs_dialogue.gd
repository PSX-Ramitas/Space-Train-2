extends GutTest

var Level = ResourceLoader.load('res://Tests/Resources/test_hub_npcs_dialogue.tscn')
var _level = null
var _player = null
var _catDroid = null
var _guide = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerTD')
	_catDroid = _level.get_node('CatDroid')
	_guide = _level.get_node('Guide')

func after_each():
	_sender.release_all()
	_sender.clear()
	pause_before_teardown()

func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_catDroid, 'catDroid does not exists')
	assert_not_null(_guide, 'guide does not exists')

func test_cat_interaction_area():
	_sender.action_down("right").hold_for(0.5)
	await(_sender.idle)
	assert_true(_catDroid.dialogue.visible, "catDroid Dialogue not visible")
	assert_eq("Hello", _catDroid.dialogue.text, "catDroid did not say hello")
	assert_true(_catDroid.NPC_dialogue, "catDroid Dialogue options not available")
	assert_eq(0, _catDroid.current_state, "catDroid did not go to state IDLE")

func test_cat_interaction_area_exit():
	_sender.action_down("right").hold_for(0.5)
	await(_sender.idle)
	assert_true(_catDroid.dialogue.visible, "catDroid Dialogue not visible")
	assert_eq("Hello", _catDroid.dialogue.text, "catDroid did not say hello")
	assert_true(_catDroid.NPC_dialogue, "catDroid Dialogue options not available")
	assert_eq(0, _catDroid.current_state, "catDroid did not go to state IDLE")
	_sender.action_down("left").hold_for(0.5)
	await(_sender.idle)
	
	# Exit
	assert_eq("Adios Amigo", _catDroid.dialogue.text, "catDroid did not say adios")
	# Timer for npc to go back roaming
	await wait_seconds(2)
	assert_false(_catDroid.NPC_dialogue, "catDroid Dialogue options available")
	assert_false(_catDroid.dialogue.visible, "catDroid Dialogue visible")
	assert_ne(0, _catDroid.current_state, "catDroid stayed on IDLE")

func test_cat_dialogue():
	var responses = [
		"Snail",
		"Boar",
		"Bees",
		"Droid Bot",
		"Botwheel",
		"Start again",
		"End the conversation"
	]
	_sender.action_down("right").hold_for(0.5)
	await(_sender.idle)
	
	# Start dialogue
	_sender.action_down("conversation_start").hold_for(0.5)
	await(_sender.idle)
	assert_not_null(_catDroid.ballon_scene, "Dialogue ballon not showing")
	await wait_seconds(1)
	assert_eq("Cat Droid",_catDroid.ballon.dialogue_line.character)
	
	# Enter Dialogue options
	gut.p("Selecting first monster")
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(2)
	for i in range(0,5):
		assert_eq(responses[i], _catDroid.ballon.dialogue_line.responses[i].text, "Mismatch at index %d" % i)
	assert_eq("Choose which monster you would like to know more.",_catDroid.ballon.dialogue_line.text)
	# Selecting first monster
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	assert_eq("This slimy enemy likes to wander around, not very dangerous.",_catDroid.ballon.dialogue_line.text)
	
	# Enter Dialogue options
	gut.p("Selecting second monster")
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(2)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	# Selecting second monster
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	assert_eq("This creature is very territorial.",_catDroid.ballon.dialogue_line.text)
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	assert_eq("It will chase you if you enter its territory.",_catDroid.ballon.dialogue_line.text)

	
	# Enter Dialogue options
	gut.p("Selecting fithf monster")
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(2)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	# Selecting third monster
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(2)
	assert_eq("Trained killer, he shots you on sight be careful.",_catDroid.ballon.dialogue_line.text)

	# Enter Dialogue options
	gut.p("Exiting")
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(2)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	_sender.action_down("ui_down").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(0.5)
	# Selecting third monster
	_sender.action_down("interact").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(2)
	assert_null(_catDroid.ballon)
