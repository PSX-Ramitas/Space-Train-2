extends GutTest

class TestBoar:
	extends GutTest
	
	var Level = ResourceLoader.load("res://Tests/Resources/MonstersTests/test_snail_monster.tscn")
	var _level = null
	var _player = null
	var  _boar = null
	var _sender = InputSender.new(Input)

	func before_each():
		_level = add_child_autofree(Level.instantiate())
		_player = _level.get_node('PlayerSS')
		_boar = _level.get_node('Boar')

	func test_verify_setup():
		assert_not_null(_player, 'player does not exists')
		assert_not_null(_boar, 'boar does not exists')

	func after_each():
		_sender.release_all()
		_sender.clear()
		pause_before_teardown()

	func test_boar_can_die():
		await wait_seconds(1)
		for child in _boar.get_children():
			if (child is Damageable):
				print(_boar.name + " took " + str(80) + " damage")
				var direction_to_damageable = (_boar.global_position - get_parent().global_position)
				var direction_sign = sign(direction_to_damageable.x)
				if(direction_sign > 0):
					child.hit(80, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(80, Vector2.LEFT)
				else:
					child.hit(80, Vector2.ZERO)
		await wait_seconds(1)
		assert_null(_boar, 'boar did not die')

	func test_boar_can_move():
		var initialPosition = _boar.position.x
		gut.p(initialPosition)
		await wait_seconds(0.5)
		assert_lt(_boar.position.x,initialPosition, 'boar did not move to the left')

	func test_boar_changes_direction_right():
		var direction = _boar.direction
		gut.p(direction)
		await wait_seconds(7)
		assert_ne(direction,_boar.direction, 'boar did not change direction')

	func test_boar_changes_direction_left():
		var direction = _boar.direction
		gut.p(direction)
		await wait_seconds(20)
		assert_eq(direction,_boar.direction, 'boar did not change direction')

class TestSnail:
	extends GutTest

	var Level = ResourceLoader.load("res://Tests/Resources/MonstersTests/test_snail_monster.tscn")
	var _level = null
	var _player = null
	var  _snail = null
	var _sender = InputSender.new(Input)

	func before_each():
		_level = add_child_autofree(Level.instantiate())
		_player = _level.get_node('PlayerSS')
		_snail = _level.get_node('Snail')

	func test_verify_setup():
		assert_not_null(_player, 'player does not exists')
		assert_not_null(_snail, 'snail does not exists')

	func after_each():
		_sender.release_all()
		_sender.clear()
		pause_before_teardown()

	func test_snail_can_die():
		await wait_seconds(1)
		for child in _snail.get_children():
			if (child is Damageable):
				print(_snail.name + " took " + str(20) + " damage")
				var direction_to_damageable = (_snail.global_position - get_parent().global_position)
				var direction_sign = sign(direction_to_damageable.x)
				if(direction_sign > 0):
					child.hit(20, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(20, Vector2.LEFT)
				else:
					child.hit(20, Vector2.ZERO)
		await wait_seconds(1)
		assert_null(_snail, 'snail did not die')

	func test_snail_can_move():
		var initialPosition = _snail.position.x
		gut.p(initialPosition)
		await wait_seconds(0.5)
		assert_lt(_snail.position.x,initialPosition, 'snail did not move to the left')

	func test_snail_changes_direction_right():
		var direction = _snail.direction
		gut.p(direction)
		await wait_seconds(4)
		assert_ne(direction,_snail.direction, 'snail did not change direction')

	func test_snail_changes_direction_left():
		var direction = _snail.direction
		gut.p(direction)
		await wait_seconds(10)
		assert_eq(direction,_snail.direction, 'snail did not change direction')
