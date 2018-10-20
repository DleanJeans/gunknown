extends Node2D

onready var gunner:Gunner = get_parent()
onready var FollowPath = $Steering/FollowPath

var team:TeamTag
var AICenter:AICenter
var gun_located = false

var spotted_enemies = []
var _target_enemy:Gunner

func _ready():
	AICenter = GameData.get_data('AICenter')
	yield(get_tree(), 'idle_frame')
	team = gunner.get_node('Team')
	$Vision.collision_mask = team.enemy_layer
	$RayCast.position = gunner.get_node('GunPosition').position
	$RayCast.add_exception(gunner)
	$RayCast.add_exception(gunner.get_node('Hitbox'))

func _process(delta):
	if gunner.has_gun():
		_plan_path_to_advance()
		if _spots_enemy():
			_aim()
			if _can_shoot_enemy():
				_stop()
				_shoot()
			else:
				_move_to_enemy()
		else:
			_aim_foward()
	else:
#		if not gun_located:
		if not FollowPath.path:
			_locate_gun()
			_plan_path_to_gun()
		else:
			_stop_if_got_gun()

func _plan_path_to_advance():
	if AICenter.get_distance_to_center(global_position) > 50 and not FollowPath.path:
		FollowPath.path = AICenter.get_path_to_center(global_position)

func _aim_foward():
	gunner.aim(global_position + gunner.velocity * 100)

func _spots_enemy():
	if _target_enemy:
		return true
	spotted_enemies = $Vision.get_overlapping_bodies()
	return spotted_enemies.size() > 0

func _can_shoot_enemy():
	$RayCast.cast_to = to_local(_target_enemy.position)
	var collider = $RayCast.get_collider()
	if collider:
		var collider_parent = collider.get_parent()
#		print('Collider: %s - Parent: %s - Target: %s\n' % [collider.name, collider_parent.name, _target_enemy.name])
		return collider.get_parent() == _target_enemy
	return false

func _move_to_enemy():
	if not FollowPath.path:
		FollowPath.path = AICenter.get_path_between(global_position, _target_enemy.position)

func _stop():
	FollowPath.path = null

func _aim():
	if not _target_enemy:
		_find_target()
	gunner.aim(_target_enemy.position - Vector2(0, 40))

func _find_target():
	var closest_enemy
	var closest_distance = INF
	
	for enemy in spotted_enemies:
		if enemy.dead: continue
		
		var distance = AICenter.get_distance_between(global_position, enemy.position)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	
	_target_enemy = closest_enemy

func _shoot():
	gunner.shoot()

var _target_spawner
var _path_to_spawner

func _locate_gun():
	var gun_spawners:Array = Group.get_nodes(Group.GUN_SPAWNERS)
	var closest = { 'distance':INF, 'position':Vector2() }
	var found = false
	_target_spawner = null
	_path_to_spawner = null
	
	for spawner in gun_spawners:
		if not spawner.has_gun(): continue
		found = true
		
		var distance = AICenter.get_distance_between(global_position, spawner.position)
		if distance < closest.distance:
			closest.spawner = spawner
			closest.path = AICenter.cached_path
			closest.distance = distance
			closest.position = spawner.position
	
	if found:
		_target_spawner = closest.spawner
		_path_to_spawner = closest.path

func _plan_path_to_gun():
	if not _target_spawner: return
	
	FollowPath.path = _path_to_spawner
	gun_located = true

func _stop_if_got_gun():
	if not _target_spawner.has_gun() or FollowPath.arrived:
		gun_located = false

func _physics_process(delta):
	if FollowPath.path:
		var steering = FollowPath.get_steering()
		gunner.move_towards(steering)