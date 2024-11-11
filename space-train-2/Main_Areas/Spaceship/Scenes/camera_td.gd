extends Camera2D

@onready var player = get_node("../PlayerTD")
var camera_position: Vector2
var overshoot: Vector2 = Vector2(0.3, 0.3)

# Consider adjusting 'height_offset' to achieve the desired camera height above the player
@export var height_offset = 50.0  # This raises the camera 50 pixels above the player

static func lerp_overshoot(origin: float, target: float, weight: float, overshoot: float) -> float:
	var distance: float = (target - origin) * weight
	if is_equal_approx(distance, 0.0):
		return target

	var distanceSign := signf(distance)
	var lerpValue: float = lerp(origin, target + (overshoot * distanceSign), weight)

	if distanceSign == 1.0:
		lerpValue = min(lerpValue, target)
	elif distanceSign == -1.0:
		lerpValue = max(lerpValue, target)
	return lerpValue

static func lerp_overshoot_v(from: Vector2, to: Vector2, weight: float, overshoot: Vector2) -> Vector2:
	var x = lerp_overshoot(from.x, to.x, weight, overshoot.x)
	var y = lerp_overshoot(from.y, to.y, weight, overshoot.y)
	return Vector2(x, y)

func _physics_process(delta):
	# Adjust player position for the camera by subtracting 'height_offset' from the y-coordinate
	var target_position = player.position# - Vector2(0, height_offset)
	self.camera_position = lerp_overshoot_v(self.position, target_position, 0.2, self.overshoot)
	self.position = self.camera_position
