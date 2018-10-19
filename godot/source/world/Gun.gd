class_name Gun
extends Sprite

signal shot(bullet)

export(float) var fire_delay = 0.3
export(float) var inaccuracy = 5

func shoot():
	if $DelayTimer.time_left > 0: return
	$DelayTimer.wait_time = fire_delay
	$DelayTimer.start()
	
	$AnimationPlayer.play('Recoil')
	
	var bullet:Bullet = Scenes.Bullet.instance()
	
	var bullet_rotation = rotation + deg2rad(inaccuracy) * rand_range(-1, 1)
	bullet.set_angle(bullet_rotation)
	
	bullet.shooter = get_parent()
	
	bullet.position = _get_tip_position()
	bullet.position += bullet.direction * 40
	
	var gunner_team_layer = get_parent().get_node('Team').collision_layer
	bullet.add_collision_layer(gunner_team_layer)
	
	emit_signal('shot', bullet)

func _get_tip_position():
	if flip_v:
		return $FlippedTip.global_position
	else:
		return $Tip.global_position