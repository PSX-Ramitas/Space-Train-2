extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_dungeon_level.tscn')
var _level = null
var _player = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')

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
func test_jump():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("jump").hold_for(0.5)
	await(_sender.idle)
  assert_true(!_player.is_on_floor(), "player jumped successfully")
	#gut.p(_player.position)

func test_fall():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("jump").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos == _player.position, "player fell down after jump")

func test_left_right_pressed():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("right").action_down("left").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.x == _player.position.x, "player did not move after pressing left and right")
