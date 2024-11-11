extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/PlayerTests/test_player2_level.tscn")

var _level = null
var _player = null
var  _snail = null
var _sender = InputSender.new(Input)


func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_snail = _level.get_node('Snail')
	await wait_frames(1)


func after_each():
	_sender.release_all()
	_sender.clear()
	pause_before_teardown()

func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_snail, 'snail does not exists')

func test_move_right():
	var playerStartPos = _player.position
	gut.p(playerStartPos)
	_sender.action_down("right").hold_for(1)
	await(_sender.idle)
	gut.p(_player.position)
	assert_gt(_player.position.x, playerStartPos.x, "player x position should be greater than before")

func test_move_left():
	var playerStartPos = _player.position
	gut.p(playerStartPos)
	_sender.action_down("left").hold_for(1)
	await(_sender.idle)
	gut.p(_player.position)
	assert_lt(_player.position.x, playerStartPos.x, "player x position should be greater than before")

func test_jump():
	var playerStartPos = _player.position
	gut.p(playerStartPos)
	_sender.action_down("jump").hold_for(0.1)
	await(_sender.idle)
	gut.p(playerStartPos)
	assert_true(!_player.is_on_floor(), "player should not be on ground after jump")

func test_double_jump():
	var playerStartPos = _player.position
	gut.p(playerStartPos)
	_sender.action_down("jump").hold_for(0.7)
	await(_sender.idle)
	_sender.action_down("jump").hold_for(0.1)
	await(_sender.idle)
	gut.p(playerStartPos)
	assert_true(!_player.is_on_floor(), "player should not be on ground after jump")

func test_fall():
	var playerStartPos = _player.position
	gut.p(playerStartPos)
	_sender.action_down("jump").wait_frames(100)
	await(_sender.idle)
	gut.p(_player.position)
	assert_true(_player.is_on_floor(), "player should be on ground")

func test_attack():
	await wait_seconds(1)
	_player.position = Vector2(359,193)
	_sender.action_down("left").hold_for(0.5)
	await(_sender.idle)
	_sender.action_down("attack").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	assert_null(_snail, 'snail did not die')
   
