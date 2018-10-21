extends Node2D

signal shaking(shake)

export(NodePath) var camera_node

onready var camera:Camera = get_node(camera_node)

export(float) var light_trauma = 0.25
export(float) var moderate_trauma = 0.65
export(float) var heavy_trauma = 1

export(float) var trauma_power = 2
export(float) var trauma_decay = 1

export(float) var max_angle = 2
export(float) var max_offset = 5

var trauma = 0
var shake

func shake_light():
	add_trauma(light_trauma)

func shake_moderate():
	add_trauma(moderate_trauma)

func shake_hard():
	add_trauma(heavy_trauma)

func add_trauma(value):
	trauma += value
	trauma = min(trauma, 1)

func _process(delta):
	if trauma > 0:
		trauma -= trauma_decay * delta
		trauma = max(trauma, 0)
	
	shake = pow(trauma, trauma_power)
	
	if shake > 0:
		_shake_camera()
		emit_signal('shaking', shake)

func _shake_camera():
	var angle_simplex = Random.get_simplex_2d_seed_time()
	var offset_x_simplex = Random.get_simplex_2d_seed_time(1)
	var offset_y_simplex = Random.get_simplex_2d_seed_time(2)
	
	var angle = max_angle * shake * angle_simplex
	var offset_x = max_offset * shake * offset_x_simplex
	var offset_y = max_offset * shake * offset_y_simplex
	
	camera.rotation_degrees = angle
	camera.offset = Vector2(offset_x, offset_y)