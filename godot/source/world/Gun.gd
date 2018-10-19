class_name Gun
extends Sprite

signal shot(bullet)

export(float) var fire_delay = 0.3
export(float) var inaccuracy = 5
export(int) var ammo = 10
export(int) var ammo_range = 5

onready var ammo_left:int

func _ready():
	ammo_left = ammo + rand_range(-ammo_range, ammo_range)

func shoot():
	
	if _cannot_shoot(): 
		if is_out_of_ammo():
			get_parent().free_gun()
		return
	
	ammo_left -= 1
	
	_start_delay_timer()
	_recoil()
	
	var bullet = _create_bullet()
	emit_signal('shot', bullet)

func _cannot_shoot():
	return _is_in_delay() or is_out_of_ammo()

func _is_in_delay():
	return $DelayTimer.time_left > 0

func is_out_of_ammo():
	return ammo_left <= 0

func _start_delay_timer():
	$DelayTimer.wait_time = fire_delay
	$DelayTimer.start()

func _recoil():
	$AnimationPlayer.play('Recoil')

func _create_bullet() -> Bullet:
	var bullet:Bullet = Scenes.Bullet.instance()
	
	var bullet_rotation = rotation + deg2rad(inaccuracy) * rand_range(-1, 1)
	bullet.set_angle(bullet_rotation)
	
	bullet.shooter = get_parent()
	bullet.position = _get_tip_position()
	
	var gunner_team_layer = get_parent().get_node('Team').collision_layer
	bullet.add_collision_layer(gunner_team_layer)
	
	return bullet

func _get_tip_position():
	if flip_v:
		return $FlippedTip.global_position
	else:
		return $Tip.global_position