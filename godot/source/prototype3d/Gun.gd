extends Spatial

const Bullet = preload('res://source/prototype3d/Bullet.tscn')

func shoot():
	$MuzzleFlash.show()
	$MuzzleFlash/Timer.start()
	
	var bullet = Bullet.instance()
	bullet.global_transform = $Muzzle.global_transform
	bullet.trail_color = owner.team_color
	owner.owner.add_child(bullet, true)