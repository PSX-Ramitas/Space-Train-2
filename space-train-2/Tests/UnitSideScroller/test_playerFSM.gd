extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/PlayerTests/test_player_level.tscn")


var _level = null
var _player = null
var _snail = null
var _playerFSM = null
var _states = {}
var _sender = InputSender.new(Input)


func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_snail = _level.get_node('Snail')
	_playerFSM = _player.get_node('FSM')
	for state in _playerFSM.get_children():
		_states[state.name] = state
	await wait_frames(1)


func after_each():
	_sender.release_all()
	_sender.clear()


func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_snail, 'snail does not exists')
	assert_not_null(_playerFSM, "fsm does not exists")
	assert_not_null(_states, "states does not exist")


func test_move_state():
	_sender.action_down("right").hold_for(1)
	await(_sender.idle)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	assert_eq("Run",_playerFSM.currState.name, "player can't move")


func test_jump_state():
	_sender.action_down("right").hold_for(0.5)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	wait_seconds(0.5)
	_sender.action_down("jump").hold_for(0.1)
	await(_sender.idle)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	assert_eq("Jump", _playerFSM.currState.name, "player can't jump")

func test_fall_state():
	_sender.action_down("right").hold_for(0.5)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	wait_seconds(0.5)
	_sender.action_down("jump").wait_frames(20)
	await(_sender.idle)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	assert_eq("Fall", _playerFSM.currState.name, "player can't fall")

func test_dash_state():
	_sender.action_down("right").hold_for(0.5)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	wait_seconds(0.5)
	_sender.action_down("dash").wait_frames(1)
	await(_sender.idle)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	assert_eq("Dash", _playerFSM.currState.name, "player can't dash")

func test_attack_state():
	_sender.action_down("left").hold_for(0.5)
	await(_sender.idle)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	

	gut.p("Current STATE: " + _playerFSM.currState.name)
	_sender.action_down("attack_melee").hold_for(0.5)
	await wait_seconds(0.2)
	gut.p("********Current STATE: " + _playerFSM.currState.name)
	assert_eq("Attack1", _playerFSM.currState.name, "player can't attack")
	await wait_frames(10)
	
	gut.p("Current STATE: " + _playerFSM.currState.name)
	_sender.action_down("attack_melee").hold_for(0.5)
	await wait_seconds(0.2)
	gut.p("********Current STATE: " + _playerFSM.currState.name)
	assert_eq("Attack2", _playerFSM.currState.name, "player can't attack2")
	await wait_frames(20)
	
	gut.p("Current STATE: " + _playerFSM.currState.name)
	_sender.action_down("attack_melee").hold_for(0.5)
	await wait_seconds(0.2)
	gut.p("********Current STATE: " + _playerFSM.currState.name)
	assert_eq("Attack3", _playerFSM.currState.name, "player can't attack3")

func test_die_state():
	_sender.action_down("right").hold_for(0.5)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	await wait_seconds(0.5)
	_player.health = 0
	await wait_seconds(0.1)
	gut.p("Current STATE: " + _playerFSM.currState.name)
	assert_eq("Die", _playerFSM.currState.name, "player can't die")
