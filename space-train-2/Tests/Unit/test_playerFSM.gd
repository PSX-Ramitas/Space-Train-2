extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_player_level.tscn')
var _level = null
var _player = null
var _playerFSM = null
var _states = {}
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_playerFSM = _player.get_node('FSM')
	for state in _playerFSM.get_children():
		_states[state.name] = state

func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player exists')
	assert_not_null(_playerFSM, "fsm exists")
	assert_not_null(_states, "states exist")


func test_move_state():
	gut.p("Current STATE: ")
	_sender.action_down("right").wait_frames(1)
	await(_sender.idle)
	gut.p(_playerFSM.currState)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states['Run'], "player can move")


func test_jump_state():
	gut.p("Current STATE: ")
	wait_seconds(1.5)
	_sender.action_down("jump").wait_frames(5)
	await(_sender.idle)
	gut.p(_playerFSM.currState)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states['Jump'], "player can jump")

func test_fall_state():
	gut.p("Current STATE: ")
	_sender.action_down("jump").wait_frames(20)
	await(_sender.idle)
	gut.p(_playerFSM.currState)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states['Fall'], "player can fall")

func test_dash_state():
	gut.p("Current STATE: ")
	_sender.action_down("dash").wait_frames(5)
	await(_sender.idle)
	gut.p(_playerFSM.currState)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states['Dash'], "player can dash")

func test_die_state():
	gut.p("Current STATE: ")
	_player.health = 0
	wait_frames(3)
	gut.p(_playerFSM.currState)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states['Die'], "player can die")

func test_attack_state():
	gut.p("Current STATE: ")
	_sender.action_down("attack_melee").wait_frames(1)
	await(_sender.idle)
	gut.p(_playerFSM.currState)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states['Attack1'], "player can attack")
