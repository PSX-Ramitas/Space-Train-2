extends GutTest

var my_variable

# This method is run prior to to running any test. 
# This is a great place to perform one time setup for the script.
func before_all():
	my_variable = 5  
	
# This method is called right before each test.
func before_each():
	my_variable = 5  

func test_my_variable():
	assert_eq(my_variable, 5, "my_variable should be 5 after setup")

# assert_true(condition, message)
# This checks if a condition is true.
# Use it when you expect something to evaluate to true.
func test_is_player_alive():
	var is_alive = true
	assert_true(is_alive, "The player should be alive")


# assert_false(condition, message)
# This checks if a condition is false.
# Use it when you expect something to evaluate to false.
func test_is_player_dead():
	var is_alive = false
	assert_false(is_alive, "The player should be dead")


# assert_eq(value, expected, message)
# This checks if value is equal to expected.
# It’s the most commonly used assertion, ideal for comparing calculated results with expected values.
func test_addition():
	var result = 2 + 2
	assert_eq(result, 4, "2 + 2 should equal 4")


# assert_ne(value, not_expected, message)
# This checks if value is not equal to not_expected.
# Use this when you want to confirm that two values are not equal.
func test_not_zero():
	var score = 10
	assert_ne(score, 0, "Score should not be zero")


# assert_null(value, message)
# This checks if value is null.
# Useful when verifying that an object hasn’t been initialized or has been explicitly set to null.
func test_null_object():
	var obj = null
	assert_null(obj, "Object should be null")


# assert_not_null(value, message)
# This checks if value is not null.
# Use it when you expect an object to be initialized.
func test_object_exists():
	var obj = Node2D.new()
	assert_not_null(obj, "Object should not be null")


# assert_gt(value, expected, message)
# This checks if value is greater than expected.
# Useful for range validations.
func test_score_above_min():
	var score = 50
	assert_gt(score, 10, "Score should be above minimum")


# assert_less(value, expected, message)
# This checks if value is less than expected
func test_health_below_max():
	var health = 80
	assert_lt(health, 100, "Health should be below max")
