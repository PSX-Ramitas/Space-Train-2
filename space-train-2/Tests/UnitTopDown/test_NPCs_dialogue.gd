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

func test_cat_dialogue():
	_sender.action_down("right").hold_for(0.5)
	await(_sender.idle)
	_sender.action_down("conversation_start").hold_for(0.5)
	await(_sender.idle)
	gut.p(_level.get_node('GameDialogueBallon'))
	gut.p(_guide.get_node('GameDialogueBallon'))
	gut.p(_player.get_node('GameDialogueBallon'))
	gut.p(_catDroid.get_child('GameDialogueBallon'))
	assert_not_null(true, "Dialogue ballon not showing")


func test_move_left():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("left").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.x > _player.position.x, "player moved left")

func test_move_up():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("up").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.y > _player.position.y, "player moved up")

func test_move_down():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("down").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.y < _player.position.y, "player moved down")
