extends Node2D

export(float) var mouse_weight = 0.75

func _process(delta):
	_update_position()

func _update_position():
	var player_position = get_parent().player.position
	var mouse_position = get_global_mouse_position()
	var to_mouse = mouse_position - player_position
	
	position = player_position + to_mouse * mouse_weight