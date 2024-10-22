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
	assert_true(playerStartPos.x < _player.position.x, "player x position should be greater than before")

func test_move_left():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("left").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.x > _player.position.x, "player x position should be less than before")
func test_jump():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("jump").wait_frames(10)
	await(_sender.idle)
  assert_true(!_player.is_on_floor(), "player should not be on ground after jump input")
	#gut.p(_player.position)

func test_fall():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("jump").wait_frames(100)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(_player.is_on_floor(), "player should be on ground")

func test_left_right_pressed():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("right").action_down("left").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(playerStartPos.x == _player.position.x, "player should not move after pressing left and right simultaneously")
