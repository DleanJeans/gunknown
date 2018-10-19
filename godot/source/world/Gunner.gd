class_name Gunner
extends KinematicBody2D

signal took_damage
signal died

export(float) var acceleration = 50
export(float) var max_speed = 500
export(float) var damp = 0.1

var velocity = Vector2()
var gun:Gun

var hp = 200
var dead = false

func take_damage(damage):
	hp -= damage
	emit_signal('took_damage')
	if hp <= 0 and not dead:
		die()

func die():
	dead = true
	$AnimationPlayer.play('Die')
	yield($AnimationPlayer, 'animation_finished')
	emit_signal('died')
	queue_free()

func owns_gun():
	return gun != null

func receive_gun(new_gun:Gun):
	gun = new_gun
	add_child(gun)
	gun.position = $GunPosition.position

func aim(target):
	if gun == null: return
	
	var target_position = target.position
	var to_target = target_position - position
	
	gun.look_at(target_position)
	gun.flip_v = to_target.x < 0

func shoot():
	if gun == null: return
	
	gun.shoot()

func move_right():
	velocity += Direction.RIGHT * acceleration

func move_left():
	velocity += Direction.LEFT * acceleration

func move_up():
	velocity += Direction.UP * acceleration

func move_down():
	velocity += Direction.DOWN * acceleration

func _physics_process(delta):
	_process_movement()

func _process_movement():
	velocity = velocity.clamped(max_speed)
	velocity *= 1 - damp
	
	move_and_slide(velocity)