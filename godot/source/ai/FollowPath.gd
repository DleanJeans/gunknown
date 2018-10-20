extends Seek

export(float) var threshold = 100

var path setget set_path
var index = 0

var arrived = false

func set_path(value):
	path = value
	arrived = false
	if value:
		index = 0
		target_position = value[0]

func get_steering():
	if arrived:
		return Vector2()
	
	var distance = global_position.distance_squared_to(target_position)
	if distance <= threshold * threshold:
		index += 1
		if index < path.size():
			target_position = path[index]
		else:
			arrived = true
			path = null
			index = -1
			target_position = global_position
	
	return .get_steering()