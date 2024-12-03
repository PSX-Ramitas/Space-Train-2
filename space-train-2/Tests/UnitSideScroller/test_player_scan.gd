extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_droid_level.tscn')
var _level = null
var _player = null

var _droid1 = null
var _droid2 = null
var _sender = InputSender.new(Input)
var startHealth = null

func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_droid1 = _level.get_node('Droid1')
	_droid2 = _level.get_node('Droid2')
	startHealth= _droid1.get_health()
	


func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player exists')
	assert_not_null(_droid1, "droid1 exists")
	assert_not_null(_droid2, "droid2 exists")

func test_scan():
	var playerStartPos = _player.position
	await wait_seconds(1)
	for child in _droid2.get_children():
			if (child is EnemyHitbox):
				child.take_damage(30)
	_sender.action_down("right").hold_for(2)
	await(_sender.idle)
	_droid1.position = playerStartPos
	_droid1.position.x += 100
	_sender.action_down("cast_spell").hold_for(0.5)
	await(_sender.idle)
	_sender.action_down("left").hold_for(0.5)
	_sender.action_down("cast_spell").hold_for(0.5)
	await(_sender.idle)
	await wait_seconds(1)
	assert_null(_droid2)
	assert_null(_droid1)
	pause_before_teardown()
