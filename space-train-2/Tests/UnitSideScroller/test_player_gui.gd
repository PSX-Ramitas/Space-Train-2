extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/PlayerTests/test_player_level.tscn")
var _level = null
var _player = null
var _snail = null
var _GUI = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = add_child_autofree(_level.get_node('PlayerSS'))
	_snail = add_child_autofree(_level.get_node('Snail'))

func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_snail, 'snail does not exists')

func test_dash_gui():
	_GUI = _player.find_child("DashIcon")
	assert_not_null(_GUI, 'Dash gui does not exists')
	var animation_player = _GUI.find_child("AnimationPlayer")
	assert_not_null(animation_player, 'animation does not exists')
	await wait_seconds(1)
	
	# Hard code test
	assert_false(_GUI.background.visible, "dash is still visible")
	gut.p("Cooldown animation:" + str(animation_player.current_animation_position))
	animation_player.play("Cooldown")
	await wait_seconds(2.1)
	gut.p("Cooldown animation:" + str(animation_player.current_animation_position))
	assert_gt(animation_player.current_animation_position, 1.5,"animation not finished")
	
	# Player input code test
	_sender.action_down("right").hold_for(1)
	_sender.action_down("dash").hold_for(1)
	gut.p("Cooldown animation:" + str(animation_player.current_animation_position))
	assert_gt(animation_player.current_animation_position, 1.5,"animation not finished")
	await wait_seconds(2)
	gut.p("Cooldown animation:" + str(animation_player.current_animation_position))
	assert_lt(animation_player.current_animation_position, 1.5,"animation still playing")

func duplicate_snail(obj, pos : Vector2):
	var _snail2 = obj.duplicate()
	_level.add_child(_snail2)
	_snail2.position = pos
	return _snail2
	
func test_items_gui():
	var _snail2 = null
	var snailStartPos = _snail.position
	var playerStartPos = _player.position
	_GUI = _player.find_child("inventoryGui")
	assert_not_null(_GUI, 'inventory gui does not exists')
	await wait_seconds(1)
	
	for a in range(0,10):
		_snail2 = duplicate_snail(_snail, snailStartPos)
		_sender.action_down("right").hold_for(0.1)
		await(_sender.idle)
		_snail2.position = playerStartPos
		_sender.action_down("left").hold_for(0.01)
		await(_sender.idle)
		_sender.action_down("attack_melee").hold_for(0.1)
		await wait_seconds(1)
		_sender.action_down("left").hold_for(0.1)
		await(_sender.idle)
		_sender.action_down("jump").hold_for(0.1)
		_player.position = playerStartPos
		await wait_seconds(0.5)
		gut.p("Inventory:" + str(_GUI.inventory.count_items()))
		if _GUI.inventory.count_items() > 0:
			assert_eq (1,_GUI.inventory.count_items())
			_sender.action_down("ui_use_item").hold_for(0.1)
			await(_sender.idle)
			gut.p("Inventory after use:" + str(_GUI.inventory.count_items()))
			assert_eq (0,_GUI.inventory.count_items())
