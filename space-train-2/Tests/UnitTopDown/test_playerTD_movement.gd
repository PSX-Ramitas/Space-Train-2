extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_hub_level.tscn')
var _level = null
var _player = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = add_child_autofree(_level.get_node('PlayerTD'))

func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player exists')

func test_move_right():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("right").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.x < _player.position.x, "player moved right")

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
