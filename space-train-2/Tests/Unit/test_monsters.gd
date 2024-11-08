extends GutTest

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

func test_snail_can_take_damage():
	var health = _snail.health
	gut.p(health)
	for child in _snail.get_children():
		if (child is Damageable):
			print(_snail.name + " took " + str(10) + " damage")
			child.hit(10)
	assert_lt(_snail.health, health, 'snail did not take damage')

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
