extends SpikesClass



# This function will be triggered when the player enters the spikes' area
func _on_Triggered_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		# Create an array of all animated spikes, cast to Area2D to avoid type errors
		var spikes_array = [
			$AnimateSpikes as Area2D, 
			$AnimateSpikes2 as Area2D, 
			$AnimateSpikes3 as Area2D, 
			$AnimateSpikes4 as Area2D
		]
		
		# Loop through the array and trigger each spike
		for spike in spikes_array:
			if spike:
				# Update the curr_state to ANIMATED
				spike.transition_To_active()
				
				


func _on_Triggered_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		# Create an array of all animated spikes, cast to Area2D to avoid type errors
		var spikes_array = [
			$AnimateSpikes as Area2D, 
			$AnimateSpikes2 as Area2D, 
			$AnimateSpikes3 as Area2D, 
			$AnimateSpikes4 as Area2D
		]
		
		# Loop through the array and trigger each spike
		for spike in spikes_array:
			if spike:
				# Update the curr_state to ANIMATED
				spike.transition_To_inactive()
