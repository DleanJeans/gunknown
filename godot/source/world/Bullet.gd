class_name Bullet
extends KinematicBody2D

export(float) var speed = 2000
export(float) var damage = 20
export(float) var recoil = 500

var velocity = Vector2()
var shooter
var team_name:String
var direction
var hp = 1

func set_angle(angle:float):
	direction = Vector2(1, 0).rotated(angle)
	velocity = direction * speed
	rotation = angle

func add_collision_layer(layer:int):
	$Hitbox.collision_layer |= layer

#func _ready():
#	position += direction * 40

func _physics_process(delta):
	move_and_collide(velocity * delta)

func _on_Hitbox_body_entered(body):
	var body_parent = body.get_parent()
	if body_parent is Wall or body_parent is SpawnZone:
		_lose_hp()
		$HitWallSound.play()
		yield($HitWallSound, 'finished')
		queue_free()

func _on_Hitbox_area_entered(area:Area2D):
	if hp <= 0 or not area.get_parent().name.begins_with('Gunner'): return
	
	var gunner = area.get_parent()
	var is_teammate = gunner.get_node('Team').team_name == team_name
	if gunner == shooter or is_teammate: return
	
	_lose_hp()
	
	gunner.take_damage(damage)
	gunner.velocity += direction * recoil
	
	$HitGunnerSound.play()
	yield($HitGunnerSound, 'finished')
	queue_free()

func _lose_hp():
	hp -= 1
	if hp <= 0:
		$Hitbox/Shape.disabled = true
		hide()