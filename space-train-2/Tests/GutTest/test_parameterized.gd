extends GutTest

# You can create tests that will be run multiple times and be passed multiple values.
# The test must have one and only one parameter.
# That parameter must be defaulted to call use_parameters.
# The value passed to use_parameters must be an array.
# 	Each element in the array will result in one execution of the test with that element passed in

var test_params = [[1, 2, 3], [4, 5, 6]]
func test_with_parameters(parameter=use_parameters(test_params)):
	assert_eq(parameter[0], parameter[2] - parameter[1])
	print("**--------array values--------**")
	print(parameter[0])
	print(parameter[1])
	print(parameter[2])
	print("**-------assert_eq(parameter[0], parameter[2] - parameter[1]---------**")
	print(parameter[0], " | ", parameter[2] - parameter[1])
	
func test_nothing():
	print("**----------------**")

# The first array contains the name of the parameters, the 2nd array contains the values.
var named_params = ParameterFactory.named_parameters(['a', 'b'], [[1, 2], ['one', 'two']])
func test_with_named_params(p=use_parameters(named_params)):
	assert_ne(p.a, p.b)
	print(p.a, p.b)
