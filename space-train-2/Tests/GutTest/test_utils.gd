extends GutTest

# This method will cause Gut to pause before it moves on to the next test.
func test_omg():
	pause_before_teardown()
	wait_seconds(5, "I've got time to spare")
	wait_frames(5, "That was fast")

# This will call _process or _physics_process on the passed in object and all children of the object. 
# It will call them times times and pass in delta to each call
# simulate(obj, times, delta)


# These methods exist on the GUT instance, and not in GutTest. They must all be prefixed with gut.

# Returns true if the file at the specified path has nothing in it or it does not exist, false if it there’s something.
# gut.is_file_empty(path)

# Print info to the GUI and console (if enabled). 
# gut.p(text, level=0)
