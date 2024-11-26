extends GutTest

var Level = ResourceLoader.load('res://Tests/Resources/test_player_inventory.tscn')
var _level = null
var _player = null
var _sender = InputSender.new(Input)

func before_each():
	# Reset the scene before each test
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')

func after_each():
	# Clean up the sender input actions and clear everything after each test
	_sender.release_all()
	_sender.clear()
	if _level:
		_level.queue_free()  # Ensure the level is freed after each test


func test_verify_setup():
	assert_not_null(_player, 'player exists')
	
func test_starting_inventory():
	#await(_sender.idle)
	assert_null(_player.inventory.items[0], "Inventory should be empty.")

func test_pickup_item():
	await(get_tree().create_timer(.5).timeout)
	# Check if inventory contains the item after moving
	assert_not_null(_player.inventory.items[0], "Inventory should have an item after picking up.")

func test_use_item_and_clear_inventory():
	# Check if inventory contains the item after picking up
	assert_not_null(_player.inventory.items[0], "Inventory should have an item after picking up.")

	await(get_tree().create_timer(1).timeout)
	
	# Use the item (press 'I')
	_sender.action_down("ui_use_item").hold_for(1)
	await(_sender.idle)
	
	# Ensure the frame processes after the signal emission
	await(get_tree().process_frame)  # Process the next frame to ensure the inventory is updated

	# Check if inventory is empty after using the item
	assert_null(_player.inventory.items[0], "Inventory should be empty after using the item.")

func test_use_potion_after_damage():
	# Assuming PlayerSS is properly instantiated in your level
	#_level = add_child_autofree(Level.instantiate())
	#_player = _level.get_node('PlayerSS')

	var playerStartPos = _player.position
	_sender.action_down("right").hold_for(1)
	await(_sender.idle)
	
	# Check if inventory contains the item after moving
	assert_not_null(_player.inventory.items[0], "Inventory should have an item after picking up.")
	
	# Get the health bar from the player via CanvasLayer
	var health_bar = _player.get_node("HUD/HealthBar") # Adjust this path if needed

	# Initialize health
	health_bar.init_health(100)
	
	await(get_tree().create_timer(1.0).timeout)

	# Damage the player
	health_bar._set_health(30)  # Assume the player is at 30 health now
	await(get_tree().create_timer(0.2).timeout)
	assert_eq(health_bar.value, 30, "Health bar should show 30 after damage")

	await(get_tree().create_timer(1).timeout)

	# Use the potion item to heal
	_sender.action_down("ui_use_item").hold_for(1) # Assuming "I" key is used to heal with potion
	await(_sender.idle)

	# Check that health is greater than 30 after using the potion (not fully restored to 100)
	assert_true(health_bar.value > 30, "Health should be greater than 30 after using the potion")

func test_increase_attack():
	# Pick up the item (assume the player moves right to pick it up)
	var playerStartPos = _player.position
	_sender.action_down("left").hold_for(1)
	await(_sender.idle)

	# Check if inventory contains the item after picking up
	assert_not_null(_player.inventory.items[0], "Inventory should have an item after picking up.")
	
	# Get the original attack value before using the item
	var original_attack = _player.attack
	
	# Assuming the item used is a PowerBoost or similar that increases attack
	_sender.action_down("ui_use_item").hold_for(1)  # Use the item (assuming 'I' key is used to trigger item use)
	await(_sender.idle)

	# Check that attack has increased
	assert_true(_player.attack > original_attack, "Attack should be increased after using the item.")

	# Wait for 3 seconds to allow the attack reset timer to expire
	await(get_tree().create_timer(3.0).timeout)

	# Check if the player's attack has returned to the original value
	assert_eq(_player.attack, original_attack, "Attack should return to original value after 3 seconds.")
