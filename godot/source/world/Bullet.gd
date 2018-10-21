class_name Bullet
extends KinematicBody2D

export(float) var speed = 2000
export(float) var damage = 20
export(float) var recoil = 500

var velocity = Vector2()
var shooter
var team:TeamTag
var direction
var hp = 1

func set_angle(angle:float):
	direction = Vector2(1, 0).rotated(angle)
	velocity = direction * speed
	rotation = angle

func add_collision_layer(layer:int):
	$Hitbox.collision_layer |= layer

func _ready():
	$BulletTrail.modulate = team.color
	var trail = $BulletTrail
	remove_child(trail)
	get_parent().add_child(trail)

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
	var is_teammate = gunner.get_node('Team').same(shooter)
	if gunner == shooter or is_teammate: return
	
	_lose_hp()
	
	gunner.take_damage(damage)
	gunner.velocity += direction * recoil
	
	z_index = 1
	$HitGunnerSound.play()
	yield($HitGunnerSound, 'finished')
	queue_free()

func _lose_hp():
	hp -= 1
	if hp <= 0:
		$Hitbox/Shape.disabled = true
		$Sprite.hide()
		$AnimationPlayer.play('Impact')
		velocity = Vector2()
		#$ImpactParticles.emitting = true