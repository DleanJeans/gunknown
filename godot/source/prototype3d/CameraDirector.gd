extends Spatial

export var zoom_speed = 20
export var min_size = 5

var zoom_velocity = 0

export(NodePath) var follow_node

onready var folowee = get_node(follow_node)

func _physics_process(delta):
	global_transform.origin = folowee.global_transform.origin

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			BUTTON_WHEEL_UP:
				zoom_velocity = -zoom_speed
			BUTTON_WHEEL_DOWN:
				zoom_velocity = zoom_speed

func _process(delta):
	$Camera.size = max(min_size, $Camera.size + zoom_velocity * delta)
	zoom_velocity *= 0.9