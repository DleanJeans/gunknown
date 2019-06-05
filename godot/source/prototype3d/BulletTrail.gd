tool
extends Spatial

signal disappeared

export var color = Color.white setget _set_color
export var max_scale = 100.0
export var extending_speed = 4.0
export var extending_accel = 2.0

var extending_direction = 1

func _process(delta):
	if Engine.editor_hint: return
	
	if scale.x < max_scale:
		scale.x += extending_speed * delta * extending_direction
		extending_speed += extending_accel * delta
	if scale.x < 0:
		emit_signal('disappeared')

func reverse():
	extending_direction = -1

func _set_color(value):
	color = value
	if not is_inside_tree():
		yield(self, 'ready')
	$Mesh.mesh.material.set_shader_param('color', value)