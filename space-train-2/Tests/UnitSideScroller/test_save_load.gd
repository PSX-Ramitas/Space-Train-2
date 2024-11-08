extends GutTest

var Level = ResourceLoader.load("res://Tests/Resources/PlayerTests/test_player_level.tscn")

var _level = null
var _player = null
var _saverloader = null
var _sender = InputSender.new(Input)


func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_saverloader = _level.get_node('%SaverLoader')
	await wait_frames(1)


func after_each():
	_sender.release_all()
	_sender.clear()
	pause_before_teardown()


func test_verify_setup():
	assert_not_null(_player, 'player does not exists')
	assert_not_null(_saverloader, 'saverloader does not exists')


func test_save_file_exists():
	pause_before_teardown()
	var path = _saverloader.SAVE_GAME_PATH
	gut.p(path)
	gut.p(gut.is_file_empty(path))
	assert_true(gut.is_file_empty(path), "Save file does not exists")

func test_saved_data():
	var saved_data = {}
	saved_data["player_global_position:x"] = _player.global_position.x
	saved_data["player_global_position:y"] = _player.global_position.y
	saved_data["player_health"] = _player.health
	saved_data["player_health_bar"] = _player.health
	saved_data["current_scene_path"] = get_tree().current_scene.get_name()
	
	_saverloader.save_game()
	await wait_seconds(1)
	_saverloader.load_game()
	await wait_seconds(1)
	
	gut.p(_saverloader.loaded_data["current_scene_path"])
	assert_eq(_saverloader.loaded_data["player_global_position:x"],saved_data["player_global_position:x"], "Player origin when loading scene does not match saved file data")
	assert_eq(_saverloader.loaded_data["player_global_position:y"],saved_data["player_global_position:y"], "Player origin when loading scene does not match saved file data")
	assert_eq(_saverloader.loaded_data["player_health"],saved_data["player_health"], "Player health when loading scene does not match saved file data")
	assert_eq(_saverloader.loaded_data["player_health_bar"],saved_data["player_health_bar"], "Player health when loading scene does not match saved file data")
	assert_eq(_saverloader.loaded_data["current_scene_path"],saved_data["current_scene_path"], "Player scence when loading scene does not match saved file data")

func test_load_game():
	var player_data = {}
	player_data["player_global_position:x"] = _player.global_position.x
	player_data["player_global_position:y"] = _player.global_position.y
	player_data["player_health"] = _player.health
	player_data["player_health_bar"] = _player.health
	player_data["current_scene_path"] = get_tree().current_scene.get_name()
	
	_sender.action_down("right").hold_for(1.5)
	await(_sender.idle)
	
	_saverloader.load_game()
	_saverloader.load_position()
	
	assert_eq(_saverloader.loaded_data["player_global_position:x"],player_data["player_global_position:x"], "Player origin when loading scene does not match original data")
	assert_eq(_saverloader.loaded_data["player_global_position:y"],player_data["player_global_position:y"], "Player origin when loading scene does not match original data")
	assert_eq(_saverloader.loaded_data["player_health"],player_data["player_health"], "Player health when loading scene does not match original data")
	assert_eq(_saverloader.loaded_data["player_health_bar"],player_data["player_health_bar"], "Player health when loading scene does not match original data")
	assert_eq(_saverloader.loaded_data["current_scene_path"],player_data["current_scene_path"], "Player scence when loading scene does not match original data")
