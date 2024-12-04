extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/EnvMechanics/forest_room_6.tscn")
var _level = null
var _player = null

var _timer = null
var _sender = InputSender.new(Input)
var startHealth = null

func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_timer = _level.find_child('SpeedrunTimer')
	startHealth= _player.get_health()
	


func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_timer, "timer does not exists")

func test_timer_start():
	var playerStartPos = _player.position
	await wait_seconds(1)
	gut.p(_timer.timer_started)
	assert_false(_timer.timer_started, 'Timer started before player walked')
	_sender.action_down("right").hold_for(0.5)
	await(_sender.idle)
	gut.p(_timer.timer_started)
	assert_true(_timer.timer_started, 'Timer did not start')
	await wait_seconds(1)

func test_timer_end():
	var playerStartPos = _player.position
	await wait_seconds(1)
	gut.p(_timer.timer_started)
	assert_false(_timer.timer_started, 'Timer started before player walked')
	_sender.action_down("right").hold_for(0.5)
	await(_sender.idle)
	gut.p(_timer.timer_started)
	assert_true(_timer.timer_started, 'Timer did not start')
	gut.p(_player.health)
	assert_eq(startHealth, _player.health, "Player took damage before timer ended, check monster")
	_timer.time = 5.0
	await wait_seconds(5)
	Engine.time_scale = 0.5
	gut.p(_player.health)
	await wait_seconds(0.5)
	assert_eq(0, _player.health, "Player didn't take max damage")
	await wait_seconds(0.5)
	Engine.time_scale = 1
