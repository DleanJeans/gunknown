extends Node2D

export(bool) var enabled = true setget set_enabled

func set_enabled(enable):
	enabled = enable
	set_physics_process(enable)

func _physics_process(delta):
	_process_movement()

func _process_movement():
	if Input.is_action_just_pressed('left'):
		pass
	if Input.is_action_just_pressed('right'):
		pass
	if Input.is_action_just_pressed('up'):
		pass
	if Input.is_action_just_pressed('down'):
		pass