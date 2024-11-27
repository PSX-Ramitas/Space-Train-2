extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/PlayerTests/test_player_level.tscn")
var _level = null
var _player = null
var _snail = null
var _GUI = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')

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
	
	# Hard code test
	assert_false(_GUI.background.visible, "dash is still visible")
	animation_player.play("Cooldown")
	await wait_seconds(2.1)
	assert_true(_GUI.background.visible, "dash icon not visible")
	
	# Player input code test
	gut.p(animation_player.current_animation_position)
	assert_gt(animation_player.current_animation_position, 1.5,"animation not finished")
	_sender.action_down("right").hold_for(1)
	_sender.action_down("dash").hold_for(1)
	await(_sender.idle)
	gut.p(animation_player.current_animation_position)
	assert_lt(animation_player.current_animation_position, 1.5,"animation not finished")
	
