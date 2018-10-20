extends Node2D

export(bool) var enabled = false setget set_enabled

var player_ref:WeakRef
var player

func _ready():
	set_physics_process(false)

func set_player(player):
	self.player = player
	player_ref = weakref(player)
	self.enabled = player != null

func set_enabled(enable):
	enabled = enable
	set_physics_process(enable)

func _physics_process(delta):
	if player_ref.get_ref():
		_process_movement()
		_process_mouse()
	else:
		self.enabled = false

func _process_movement():
	if Input.is_action_pressed('shoot'):
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
	var mouse_position = get_global_mouse_position()
	player.aim(mouse_position)