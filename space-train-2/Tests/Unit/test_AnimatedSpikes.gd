extends GutTest


var Level = ResourceLoader.load('res://Tests/Resources/test_spikes_level.tscn')
var _level = null 
var _player = null
var	_spikes1 = null
var	_spikes2 = null
var	_spikes3 = null
var _sender = InputSender.new(Input)

func before_each():
	_level = add_child_autofree(Level.instantiate())
	_player = _level.get_node('PlayerSS')
	_spikes1 = _level.get_node('AnimateSpikes')
	_spikes2 = _level.get_node('AnimateSpikes2')
	_spikes3 = _level.get_node('AnimateSpikes3')
	
func after_each():
	_sender.release_all()
	_sender.clear()
	
func test_verify_setup():
	assert_not_null(_player,"Player does exist")
	assert_not_null(_spikes1,"Spike1 does exist")
	assert_not_null(_spikes2,"Spikes2 does exist")
	assert_not_null(_spikes3,"Spikes3 does exist")

#active spikes
func test_ContactDamage():
	var startHealth = _player.health
	_sender.action_down("right").hold_for(1)
	_spikes1.active_Spikes()
	_spikes2.active_Spikes()
	_spikes3.active_Spikes()

	_sender.action_down("left").hold_for(2)
	_sender.action_down("right").hold_for(2)
	_sender.action_down("left").hold_for(1)
	_sender.idle
	await(_sender.idle)
	assert_true(startHealth > _player.health, "Spikes can damage player")

	
#inactive spikes
func test_InactiveContact():
	var startHealth = _player.health
	_spikes1.inactive_Spikes()
	_spikes2.inactive_Spikes()
	_spikes3.inactive_Spikes()
	await (get_tree().create_timer(2.0)).timeout  # Waits for 2 seconds
	assert_true(startHealth == _player.health, "Inactive Spikes does Does not damage player")
	

#animatedSpikes
func test_AnimationofSpikes():
	_spikes1.active_animated_Spikes()
	assert_eq(_spikes1.curr_state, _spikes1.spike_state.ANIMATED, "Spike should be in ANIMATED state after calling" )

func test_transition_To_active():
	_spikes2.transition_To_active()
	
	#Calculate the margin of error (2% of the expected value)
	var margin_of_error = _spikes2.pause_frame * 0.15
	
	# Wait for the timer (pause frame duration) to reach the stop frame
	await get_tree().create_timer(_spikes2.pause_frame).timeout
	# Check that the animation stops at the specified frame
	var paused_frame = _spikes2.get_node('AnimatedSpikes').get_current_animation_position()
	assert_true(abs(paused_frame - _spikes2.pause_frame) <= margin_of_error, "Animation should stop at pause_frame with 2% margin")
	# Check if the state has transitioned to ACTIVE after stopping
	assert_eq(_spikes2.curr_state, _spikes2.spike_state.ACTIVE, "Spike should transition to ACTIVE state after reaching pause_frame in transition_To_active")

func test_transition_To_inactive():
	_spikes3.transition_To_inactive()
	
	# Check if the state is set to DOWN_ANI
	assert_eq(_spikes3.curr_state, _spikes3.spike_state.DOWN_ANI, "Spike should be in INACTIVE state after calling transition_To_inactive")
	# Check if the "going_down" animation is playing
	assert_true(_spikes3.get_node('AnimatedSpikes').is_playing(), "The going_down animation should be playing after calling transition_To_inactive")
	# Wait until the animation is finished
	await _spikes3.get_node('AnimatedSpikes').animation_finished
	# Verify that the state changes to INACTIVE after the animation
	assert_eq(_spikes3.curr_state, _spikes3.spike_state.INACTIVE, "Spike should be in INACTIVE state after the going_down animation finishes")
	assert_false(_spikes3.is_transitioning, "is_transitioning should be false after transition completes")
