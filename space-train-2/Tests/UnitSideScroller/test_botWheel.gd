extends GutTest
class TestBotWheel:
	extends GutTest
	var Level = ResourceLoader.load("res://Tests/Resources/MonstersTests/test_botWheel.tscn")

	var _level = null
	var _player = null

	var _botWheel = null
	var _botWheel2 = null
	var _sender = InputSender.new(Input)

	func before_each():
		_level = add_child_autofree(Level.instantiate())
		_player = _level.get_node('PlayerSS')
		_botWheel = _level.get_node('botWheel')
		_botWheel2 = _level.get_node('botWheel2')
	
	func after_each():
		_sender.release_all()
		_sender.clear()

	func test_verify_setup():
		assert_not_null(_player, 'player exists')
		assert_not_null(_botWheel, "botWheel exists")
		assert_not_null(_botWheel2, "botWheel exists")

	func test_chase():
		var startDistance = _player.position.x - _botWheel.position.x
		wait_seconds(3)
		var currDistance = _player.position.x - _botWheel2.position.x
		assert_true(startDistance > currDistance, "botWheel moved towards player")

	func test_botWheel_can_die():
		await wait_seconds(1)
		for child in _botWheel.get_children():
			if (child is EnemyHitbox):
				child.take_damage(45)
				
		await wait_seconds(1)
		assert_null(_botWheel, 'botWheel did not die')

#func test_no_attack():
	#assert_true(_botWheel.state != "Attack", "botWheel can't attack player out of range")
