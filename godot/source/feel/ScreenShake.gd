extends Node2D

export(NodePath) var camera_node
export(float) var strength = 10
export(float) var duration = 0.2

onready var camera:Camera = get_node(camera_node)
onready var half_duration = duration * 0.5

func shake_to(direction:Vector2, multiplier = 1):
	return
	var to = direction * strength * multiplier
	
	$Tween.stop_all()
	$Tween.interpolate_property(camera, 'offset', Vector2(), to, half_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT, half_duration)
	$Tween.interpolate_property(camera, 'offset', to, Vector2(), half_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()