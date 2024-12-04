extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/EnvMechanics/forest_room_5.tscn")
var Level2 = ResourceLoader.load("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")
var _level = null
var _level2 = null
var _player = null

var _npc = null
var _sender = InputSender.new(Input)
var startHealth = null

func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = add_child_autofree(_level.get_node('PlayerSS'))
	_npc = add_child_autofree(_level.get_node('LostGuy'))
	startHealth= _player.get_health()
	
func after_each():
	_sender.release_all()
	_sender.clear()

func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_npc, "npc does not exists")

func test_npc_start():
	var playerStartPos = _player.position
	_player.position = Vector2(5983,312)
	#gut.p(_npc.interacted)
	assert_false(_npc.interacted)
	await wait_seconds(1)
	_sender.action_down("right").hold_for(0.3)
	wait_seconds(0.5)
	_player.position.x += 200
	_sender.action_down("conversation_start")
	await(_sender.idle)
	await wait_seconds(1.5)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	await wait_seconds(2)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	await wait_seconds(1.5)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	await wait_seconds(1.5)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	assert_true(_npc.interacted)
	pause_before_teardown()
	
func test_npc_goes_to_spaceship():
	var playerStartPos = _player.position
	_player.position = Vector2(5983,312)
	#gut.p(_npc.interacted)
	assert_false(_npc.interacted)
	await wait_seconds(1)
	_sender.action_down("right").hold_for(0.3)
	wait_seconds(0.5)
	_player.position.x += 200
	_sender.action_down("conversation_start")
	await(_sender.idle)
	await wait_seconds(1.5)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	await wait_seconds(2)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	await wait_seconds(1.5)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	await wait_seconds(1.5)
	_sender.action_down("interact").hold_for(0.1)
	await(_sender.idle)
	assert_true(_npc.interacted)
	_level.levelFinished == true
	TrainNPCs.lostGuyInteracted = true
	
	# Spaceship tests
	_level.queue_free()
	_level2 = add_child_autofree(Level2.instantiate())
	_player = _level2.get_node('PlayerTD')
	var _catDroid = _level2.get_node('CatDroid')
	var _npcTD =_level2.get_node('LostGuyTD')
	await wait_seconds(0.5)
	assert_not_null(_catDroid)
	assert_not_null(_npcTD)
	_sender.release_all()
	_sender.clear()
	_level2.queue_free()
	pause_before_teardown()
