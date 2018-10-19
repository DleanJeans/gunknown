extends Node2D

export(bool) var enabled = true setget set_enabled
export(NodePath) var player_path

onready var player:Gunner = get_node(player_path)

func set_enabled(enable):
	enabled = enable
	set_physics_process(enable)

func _physics_process(delta):
	_process_movement()
	_process_mouse()

func _process_movement():
	if Input.is_action_just_pressed('shoot'):
		player.shoot()
	if Input.is_action_pressed('left'):
		player.move_left()
	if Input.is_action_pressed('right'):
		player.move_right()
	if Input.is_action_pressed('up'):
		player.move_up()
	if Input.is_action_pressed('down'):
		player.move_down()

func _process_mouse():
	var mouse_target = { 'position': get_global_mouse_position() }
	player.aim(mouse_target)