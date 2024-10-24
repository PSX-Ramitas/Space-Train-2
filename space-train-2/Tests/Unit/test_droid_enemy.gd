extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_droid_level.tscn')
var _level = null
var _player = null
var _droid1 = null
var _droid2 = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_droid1 = _player.get_node('Droid1')
	_droid2 = _player.get_node('Droid2')
func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player exists')
	assert_not_null(_droid1, "droid1 exists")
	assert_not_null(_droid2, "droid2 exists")


func test_chase():
	pass

func test_attack():
	pass

func test_hurt():
	pass

func test_killed():
	pass
