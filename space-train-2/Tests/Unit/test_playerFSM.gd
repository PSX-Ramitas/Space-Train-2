extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_dungeon_level.tscn')
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
	gut.p(_states)


func test_move_state():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("right").wait_frames(1)
	await(_sender.idle)
	#gut.p(_player.position)
	#might need to be currState.name or currState.to_str()
	assert_true(_playerFSM.currState == _states[RunState], "player can move")
