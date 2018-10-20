extends Node2D

export(float) var mouse_weight = 0.75

var player:Gunner
var player_ref:WeakRef

func set_player(player):
	self.player = player
	player_ref = weakref(player)
	set_process(player != null)

func _ready():
	set_process(false)

func _process(delta):
	if player_ref.get_ref():
		_update_position()
	else:
		set_process(false)

func _update_position():
	var player_position = player.position
	var mouse_position = get_global_mouse_position()
	var to_mouse = mouse_position - player_position
	
	position = player_position + to_mouse * mouse_weight