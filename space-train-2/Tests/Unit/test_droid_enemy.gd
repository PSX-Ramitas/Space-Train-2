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
	var startDistance = abs(_player.position.x - _droid2.position.x)
	wait_seconds(3)
	var currDistance = abs(_player.position.x - _droid2.position.x)
	assert_true(startDistance > currDistance, "Droid moved towards player")

func test_no_attack():
	assert_true(_droid2.get_state() != 2, "Droid can't attack player out of range")
#
#func test_attack():
	#startHealth = _player.health
	#_sender.action_down("right").hold_for(1)
	#await(_sender.idle)
	#wait_seconds(1.5)
	#assert_true(_droid1.state == "Attack" and _player.health < startHealth, "Droid can attack")
#
#func test_hurt():
	##make the player attack the droid and assert that it's health is now lower (similar to chase but with health)
	#var startHealth = _droid1.health
	#_sender.action_down("right").hold_for(1)
	#_sender.action_down("left").wait_frames(9)
	#_sender.action_down("attack_melee").wait_frames(5)
	#await(_sender.idle)
	#wait_seconds(1)
	#assert_true(start_health > _droid1.health, "Droid can take damage")
	#pass
#
#func test_killed():
	#_droid1.health = 0
	#wait_seconds(2)
	#assert_true(_droid1 == null, "droid can die")
	#pass
