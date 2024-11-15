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


func test_chase():
	var startDistance = abs(_player.position.x - _droid2.position.x)
	gut.p(startDistance)
	await wait_seconds(3)
	var currDistance = abs(_player.position.x - _droid2.position.x)
	gut.p(currDistance)
	print("start distance: ", startDistance, ", currDistance: ", currDistance)
	assert_true(startDistance > currDistance, "Droid moved towards player")

#func test_no_attack():
	#assert_true(_droid2.state != "Attack", "Droid can't attack player out of range")

func test_attack():
	var startHealth = _player.health
	_sender.action_down("right").hold_for(2)
	await(_sender.idle)
	if _droid2.currentState==2:
		assert_true(_player.health < startHealth, "Droid can't attack")

func test_hurt():
	#make the player attack the droid and assert that it's health is now lower (similar to chase but with health)
	startHealth = _droid1.health
	_sender.action_down("right").hold_for(2)
	#_sender.action_down("left").wait_frames(9)
	_sender.action_down("attack_melee").wait_frames(5)
	await(_sender.idle)
	wait_seconds(1)
	assert_true(startHealth > _droid2.health, "Droid can take damage")

func test_killed():
	_droid1.health = 0
	_droid2.health = 0
	await wait_seconds(2)
	assert_true(_droid1 == null, "droid can die")
