extends Area

const BulletParticles = preload('res://source/prototype3d/BulletParticles.tscn')

export var speed = 50
export var damage_range = Vector2(100, 150)
export var trail_color = Color.white setget _set_trail_color

func _physics_process(delta):
	global_transform.origin += Vector3(speed, 0, 0).rotated(Vector3.UP, rotation.y) * delta

func stop_to_free():
	$Mesh.hide()
	set_physics_process(false)
	$Trail.reverse()
	yield($Trail, 'disappeared')
	queue_free()

func _deal_damage(body):
	var damage = round(rand_range(damage_range.x, damage_range.y))
	body.take_damage(damage)

func _on_body_entered(body):
	if body is Gunner:
		$CollisionShape.disabled = true
		$AnimationPlayer.play('explode')
		stop_to_free()
		_pushback(body)
		_deal_damage(body)
		
		var p = BulletParticles.instance()
		get_parent().add_child(p)
		p.global_transform.origin = global_transform.origin
		var velocity = Vector3(speed, 0, 0).rotated(Vector3.UP, rotation.y)
		var angle = Vector2(velocity.x, velocity.z).angle()
		p.rotation.y = -angle - PI * 0.5
		p.material_color = trail_color
		p.add_child(SelfDestruct.new(p.lifetime))
		p.emitting = true
		

func _pushback(body):
	var pushback = Pushback.new(self)
	body.add_child(pushback)

func _set_trail_color(value):
	trail_color = value
	$Trail.color = value