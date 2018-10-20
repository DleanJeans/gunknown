class_name GunSpawner
extends Node2D

signal spawned_gun(gun)

signal gunner_entered(gunner)
signal gunner_exited(gunner)

export(float) var spawn_interval = 30
export(float) var random_offset = 5

func _ready():
	$AnimationPlayer.playback_speed = rand_range(0.4, 0.6)

func has_gun():
	return $Gun.visible

func _on_PickupArea_area_entered(area:Area2D):
	var gunner:Gunner = area.get_parent()
	if $Gun.visible:
		emit_signal('gunner_entered', gunner)

func _on_PickupArea_area_exited(area:Area2D):
	var gunner:Gunner = area.get_parent()
	emit_signal('gunner_exited', gunner)

func get_gun() -> Gun:
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