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
		gut.p("initiliazing")
		_level = add_child_autofree(Level.instantiate())
		_player = add_child_autofree(_level.get_node('PlayerSS'))
		_botWheel = add_child_autofree(_level.get_node('botWheel'))
		_botWheel2 = add_child_autofree(_level.get_node('botWheel2'))
	
	func after_each():
		gut.p("releasing")
		_sender.release_all()
		_sender.clear()

	func test_verify_setup():
		gut.p("verify not null")
		assert_not_null(_player, 'player exists')
		assert_not_null(_botWheel, "botWheel exists")
		assert_not_null(_botWheel2, "botWheel exists")

	func test_chase():
		gut.p("testing botwheel chase")
		var startDistance = _player.position.x - _botWheel.position.x
		await wait_seconds(3)
		var currDistance = _player.position.x - _botWheel2.position.x
		assert_true(startDistance > currDistance, "botWheel moved towards player")

	func test_botWheel_can_die():
		gut.p("testing botwheel dying")
		for child in _botWheel.get_children():
			if (child is EnemyHitbox):
				child.take_damage(55)
		for child in _botWheel2.get_children():
			if (child is EnemyHitbox):
				child.take_damage(55)
		await wait_seconds(3)
		assert_null(_botWheel, 'botWheel did not die')
		assert_null(_botWheel2, 'botWheel did not die')


	func test_attack():
		gut.p("botwheel attack test")
		var startHealth = _player.health
		_sender.action_down("left").hold_for(3)
		await(_sender.idle)
		if _botWheel.currentState==1:
			assert_true(_player.health < startHealth, "botwheel can't attack")
		if _botWheel2.currentState==1:
			assert_true(_player.health < startHealth, "botwheel2 can't attack")

	func test_hurt():
		gut.p("testing botwheeling getting hurt")
		#make the player attack the droid and assert that it's health is now lower (similar to chase but with health)
		var startHealth = _botWheel.health
		_sender.action_down("left").hold_for(2)
		#_sender.action_down("left").wait_frames(9)
		_sender.action_down("attack_melee").wait_frames(5)
		await(_sender.idle)
		wait_seconds(1)
		assert_true(startHealth > _botWheel.health, "botWheel can take damage")

	func test_no_attack():
		gut.p("idk")
		assert_true(_botWheel.currentState != 2, "botWheel can't attack player out of range")
