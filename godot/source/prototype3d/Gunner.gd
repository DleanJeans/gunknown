tool
extends KinematicBody
class_name Gunner

const DeathParticles = preload('res://source/prototype3d/DeathParticles.tscn')

signal took_damage
signal no_health
signal died

export var base_health = 200 setget _set_base_health
export var speed = 50.0
export var damp = 0.1
export var team_color = Color.white setget _set_team_color

var velocity = Vector3()
var health = base_health setget _set_health

func shoot():
	$Gun.shoot()
	$AnimationPlayer.play('shoot')

func take_damage(damage):
	self.health = max(0, health - damage)
	emit_signal('took_damage')

func die():
	$Shape.disabled = true
	
	_update_die_animation_color()
	_remove_gun()
	_emit_particles()
	
	$AnimationPlayer.play('die')
	yield($AnimationPlayer, 'animation_finished')
	emit_signal('died')

func _emit_particles():
	var p = DeathParticles.instance()
	get_parent().add_child(p)
	p.global_transform.origin = global_transform.origin
	var angle = Vector2(velocity.x, velocity.z).angle()
	p.rotation.y = -angle + PI * 0.5
	p.material_color = team_color
	p.emitting = true

func _update_die_animation_color():
	var die_animation = $AnimationPlayer.get_animation('die')
	var ring_modulate = die_animation.find_track('Ring:modulate')
	var transparent = $Ring.modulate; transparent.a = 0
	
	die_animation.track_set_key_value(ring_modulate, 0, $Ring.modulate)
	die_animation.track_set_key_value(ring_modulate, 1, transparent)

func _remove_gun():
	if not has_node('Gun'): return
	
	var gun = $Gun
	var origin = gun.global_transform.origin
	remove_child(gun)
	get_parent().add_child(gun)
	gun.global_transform.origin = origin

func _ready():
	$Mesh.mesh = $Mesh.mesh.duplicate(true)

func _physics_process(delta):
	if Engine.editor_hint: return
	
	move_and_slide(velocity)
	velocity *= 1 - damp

func _process(delta):
	$Ring.rotation = -rotation

func _set_team_color(value):
	team_color = value
	$Ring.modulate = value

func _set_base_health(value):
	base_health = value
	$Ring.max_hp = value

func _set_health(value):
	health = value
	$Ring.hp = value
	if value == 0:
		emit_signal('no_health')