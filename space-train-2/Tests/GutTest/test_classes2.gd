extends GutTest

class TestFeatureA:
	extends GutTest

	var Obj = load("res://Tests/Unit/testScript.gd")
	var _obj = null

	func before_each():
		_obj = Obj.new()

	func test_something():
		assert_true(_obj.is_something_cool(), 'Should be cool.')

class TestFeatureB:
	extends GutTest

	var Obj = load("res://Tests/Unit/testScript.gd")
	var _obj = null

	func before_each():
		_obj = Obj.new()

	func test_foobar():
		assert_eq(_obj.foo(), 'bar', 'Foo should return bar')
