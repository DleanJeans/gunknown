class_name Bullet
extends KinematicBody2D

export(float) var speed = 2000
export(float) var damage = 20
export(float) var recoil = 500

var velocity = Vector2()
var shooter
var direction
var hp = 1

func set_angle(angle:float):
	direction = Vector2(1, 0).rotated(angle)
	velocity = direction * speed
	rotation = angle

func add_collision_layer(layer:int):
	$Hitbox.collision_layer |= layer

func _physics_process(delta):
	move_and_collide(velocity * delta)

func _on_Hitbox_body_entered(body):
	var body_parent = body.get_parent()
	if body_parent is Wall or body_parent is SpawnZone:
		_lose_hp()

func _on_Hitbox_area_entered(area:Area2D):
	if hp <= 0: return
	
	var gunner = area.get_parent()
	if gunner == shooter: return
	
	_lose_hp()
	
	var is_teammate = gunner.get_node('Team').same(shooter)
	if is_teammate: return
	gunner.take_damage(damage)
	gunner.velocity += direction * recoil

func _lose_hp():
	hp -= 1
	if hp <= 0:
		$Hitbox/Shape.disabled = true
		queue_free()