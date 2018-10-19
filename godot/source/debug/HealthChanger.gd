extends Node2D

export(int) var hp = 5
export(bool) var kill_allowed = false

func _process(delta):
	var player = get_parent().player
	if Input.is_action_pressed('increase_health'):
		player.hp = clamp(player.hp + hp, 10, 200)
	elif Input.is_action_pressed('decrease_health'):
		if kill_allowed:
			player.take_damage(hp)
		else:
			player.hp = clamp(player.hp - hp, 10, 200)
