extends GutTest

var Level = ResourceLoader.load('res://tests/resources/test_dungeon_level.tscn')
var _level = null
var _player = null
var _playerFSM = null
var _sender = InputSender.new(Input)
func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
  _playerFSM = _player.get_node('FSM')

func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player exists')
  assert_not_null(_playerFSM, "fsm exists")

func test_move_state():
	var playerStartPos = _player.position
	#gut.p(playerStartPos)
	_sender.action_down("right").hold_for(1)
	await(_sender.idle)
	#gut.p(_player.position)
	assert_true(_playerFSM.currState == RunState, "player can move")
