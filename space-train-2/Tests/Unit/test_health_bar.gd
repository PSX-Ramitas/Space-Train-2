extends GutTest

var HealthBarScene = ResourceLoader.load('res://Tests/Resources/test_health_bar.tscn')
var health_bar = null

# Setup before each test
func before_each():
	health_bar = add_child_autofree(HealthBarScene.instantiate())

# Cleanup after each test
func after_each():
	if is_instance_valid(health_bar):  # Check if health_bar is still valid
		health_bar.queue_free()

# Test: Verify health bar initialization
func test_health_initialization():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	assert_eq(health_bar.value, 100, "Health bar should initialize to 100")
	assert_eq(health_bar.max_value, 100, "Max value should be set to 100")
	assert_eq(health_bar.damage_bar.value, 100, "Damage bar should also initialize to 100")

# Test: Ensure health value is clamped between 0 and max_value
func test_health_clamping():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	# Test health above max
	health_bar._set_health(150)
	await(get_tree().process_frame)
	assert_eq(health_bar.value, 100, "Health should not exceed the max value")

	# Test health below 0
	health_bar._set_health(-10)
	await(get_tree().process_frame)
	assert_eq(health_bar.value, 0, "Health should not go below 0")

# Test: Health decreases and damage bar tweens properly
func test_health_decrease_with_damage_tween():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	# Simulate damage
	health_bar._set_health(80)
	await(get_tree().process_frame)
	# Verify damage tween exists and animates the correct property
	assert_true(health_bar.damage_tween != null, "Damage tween should be created")

	# Wait for tween to finish and validate final state
	await(get_tree().create_timer(0.5).timeout)
	assert_eq(health_bar.damage_bar.value, 80, "Damage bar value should match health after tween completes")


# Test: Verify health bar behavior when health reaches 0
func test_health_reaches_zero():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	# Simulate health reaching 0
	health_bar._set_health(0)
	await(get_tree().process_frame)

	assert_eq(health_bar.value, 0, "Health bar should be 0 when health reaches zero")

	# Wait for the tween to complete (if applicable)
	await(get_tree().create_timer(0.5).timeout)

	# Check if health_bar is still valid
	assert_false(is_instance_valid(health_bar), "Health bar shouldn't still be valid after 0 health is set")

# Test: Verify health increases but doesn't exceed max value
func test_health_increase():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	# Simulate taking damage
	health_bar._set_health(50)
	await(get_tree().process_frame)
	assert_eq(health_bar.value, 50, "Health should update to 50 after damage")

	# Simulate healing
	health_bar._set_health(80)
	await(get_tree().process_frame)
	assert_eq(health_bar.value, 80, "Health should increase to 80")

	# Test healing beyond max health
	health_bar._set_health(150)
	await(get_tree().process_frame)
	assert_eq(health_bar.value, 100, "Health should not exceed max value of 100")

# Test: Verify timer triggers damage bar update
func test_timer_updates_damage_bar():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	# Simulate damage and wait for timer
	health_bar._set_health(60)
	await(get_tree().create_timer(0.5).timeout)

	assert_eq(health_bar.damage_bar.value, 60, "Damage bar should match health after timer timeout")

# Test: Verify health bar queues free properly
func test_health_bar_queues_free_on_zero_health():
	health_bar.init_health(100)
	await(get_tree().process_frame)

	health_bar._set_health(0)
	await(get_tree().create_timer(0.5).timeout)
	assert_false(is_instance_valid(health_bar), "Health bar should queue_free after reaching 0 health")
