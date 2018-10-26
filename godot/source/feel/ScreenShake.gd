extends Node2D

export(float) var strength = 10
export(float) var duration = 0.2

var camera:Camera2D
onready var half_duration = duration * 0.5

func shake_to(direction:Vector2, multiplier = 1):
	if OS.get_name() == 'HTML5' or not camera:
		return
	var to = direction * strength * multiplier
	
	$Tween.stop_all()
	$Tween.interpolate_property(camera, 'offset', Vector2(), to, half_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT, half_duration)
	$Tween.interpolate_property(camera, 'offset', to, Vector2(), half_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()