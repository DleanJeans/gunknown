class_name TimeControl
extends Node2D

export(float) var slomo_time_scale = 0.25

var _in_slomo = false

func _process(delta):
	if Input.is_action_just_pressed('slomo'):
		if _in_slomo:
			disable()
		else:
			enable()
		_in_slomo = not _in_slomo

func enable():
	Engine.time_scale = slomo_time_scale

func disable():
	Engine.time_scale = 1