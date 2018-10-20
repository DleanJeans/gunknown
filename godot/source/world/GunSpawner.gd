class_name GunSpawner
extends Node2D

signal spawned_gun(gun)

export(float) var spawn_interval = 30
export(float) var random_offset = 5

var occupant:Gunner

func _ready():
	$AnimationPlayer.playback_speed = rand_range(0.4, 0.6)

func has_gun():
	return $Gun.visible

func _on_PickupArea_area_entered(area:Area2D):
	var gunner:Gunner = area.get_parent()
	if $Gun.visible:
		_give_gun_if_has_no_gun(gunner)

func _give_gun_if_has_no_gun(gunner):
	if not gunner.has_gun():
		_give_gun(gunner)

func _give_gun(gunner:Gunner):
	var gun = _get_gun()
	gunner.receive_gun(gun)

func _get_gun():
	var gun = Scenes.Gun.instance()
	emit_signal('spawned_gun', gun)
	
	$Gun.hide()
	
	_start_timer()
	$AnimationPlayer.play('Disappear')
	
	return gun

func _start_timer():
	var duration = spawn_interval + random_offset * rand_range(-1, 1) 
	$Timer.wait_time = duration
	$Timer.start()

# $Timer.timeout
func _spawn_gun():
	$AnimationPlayer.play('Appear')

func _process(delta):
	var gunners = $PickupArea.get_overlapping_bodies()
	if gunners.size() > 0:
		_give_gun_if_has_no_gun(gunners[0])