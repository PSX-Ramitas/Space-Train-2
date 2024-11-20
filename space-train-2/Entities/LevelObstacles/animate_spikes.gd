extends SpikesClass

#STATES
@export var curr_state: spike_state
enum spike_state {ACTIVE, ANIMATED, INACTIVE, DOWN_ANI}

#VARIABLES
@export var pause_frame: float = 0.6  # Set the desired frame (in seconds) to pause at
var is_transitioning: bool = false  # Prevents disruption while transitioning

#SOUND
@onready var trigger: AudioStreamPlayer = $Trigger

#GENERAL ANIMATION FUNCTIONS----------------------------------------------------------------------
func _on_animated_spikes_ready() -> void:
	# Connect the animation_finished signal properly
	$AnimatedSpikes.connect("animation_finished", Callable(self, "_on_animated_spikes_animation_finished"))

func active_Spikes():
	$AnimatedSpikes.play("Active")
	curr_state = spike_state.ACTIVE

func active_animated_Spikes():
	$AnimatedSpikes.play("Spikes_Animation")
	curr_state = spike_state.ANIMATED

func inactive_Spikes():
	$AnimatedSpikes.play("inactive")
	curr_state = spike_state.INACTIVE

func going_down_Spikes():
	$AnimatedSpikes.play("Spikes_Animation")
	curr_state = spike_state.DOWN_ANI

func _process(_delta):
	match curr_state:
		spike_state.ACTIVE:
			active_Spikes()
		spike_state.ANIMATED:
			active_animated_Spikes()
		spike_state.INACTIVE:
			inactive_Spikes()


#END OF GENERAL ANIMATION FUNCTIONS-------------------------------------------------------------


# Transition to active spikes (plays the animation and halts at a specific frame)
func transition_To_active():     
	#only animate if there is no transition yet
	if is_transitioning:
		return
	is_transitioning = true #set transition state
	curr_state = spike_state.ANIMATED
	$AnimatedSpikes.play("Spikes_Animation")
	trigger.play()
	$AnimatedSpikes.speed_scale = 1.2

	# Add a timer to stop at a specific frame
	await get_tree().create_timer(pause_frame).timeout
	$AnimatedSpikes.seek(pause_frame, true)  # Seek to the specified frame
	$AnimatedSpikes.stop()  # Stop the animation at the pause frame
	
	#end of transition state
	is_transitioning = false
	curr_state = spike_state.ACTIVE


# Transition to inactive spikes after the animation finishes
func transition_To_inactive():
	if is_transitioning:
		return
	is_transitioning = true  # Prevent interruptions
	curr_state = spike_state.DOWN_ANI
	$AnimatedSpikes.play("going_down")  # Play the "going_down" animation
	$AnimatedSpikes.speed_scale = 0.5  # Slow down the animation (optional)

 #This function will be called automatically when any animation finishes
func _on_animated_spikes_animation_finished(anim_name: StringName) -> void:
	if anim_name == "going_down":  # Check if the correct animation finished
		curr_state = spike_state.INACTIVE
		$AnimatedSpikes.play("inactive")  # Play the inactive animation
		is_transitioning = false  # Allow further transitions
	
	elif anim_name == "Spikes_Animation":  # Handle when the spikes animation finishes
		transition_To_inactive()  # Trigger the transition to inactive state
