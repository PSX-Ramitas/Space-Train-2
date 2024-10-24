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
	_droid1 = _level.get_node('Droid1')
	_droid2 = _level.get_node('Droid2')

func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player exists')
	assert_not_null(_droid1, "droid1 exists")
	assert_not_null(_droid2, "droid2 exists")


func test_chase():
	#get difference between droid and player x positions, wait 3 seconds, then assert that it is smaller than before
	pass

func test_attack():
	#move the player into the droid's attacking range and assert that the droid is attacking
	pass

func test_hurt():
	#make the player attack the droid and assert that it's health is now lower (similar to chase but with health)
	pass

func test_killed():
	_droid1.health = 0
	wait_seconds(2)
	assert_true(_droid1 == null, "droid can die")
	pass
