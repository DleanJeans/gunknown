extends Node2D

onready var gunner:Gunner = get_parent()
onready var FollowPath = $Steering/FollowPath

var team:TeamTag
var AICenter:AICenter
var gun_located = false

var spotted_enemies = []
var _target_enemy:Gunner

var target_weight = 0.4
var distance_threshold = 50 * 50

func _ready():
	AICenter = GameData.get_data('AICenter')
	yield(get_tree(), 'idle_frame')
	team = gunner.get_node('Team')
	$Vision.collision_mask = team.enemy_layer
	$RayCast.position = gunner.get_node('GunPosition').position
	
	gunner.connect('died', self, '_reset')
	
	var teammates = Group.get_nodes(team.team_name)
	for gunner in teammates:
		$RayCast.add_exception(gunner)
		$RayCast.add_exception(gunner.get_node('Hitbox'))

func _reset():
	FollowPath.path = null
	_target_enemy = null

func _process(delta):
	if gunner.dead: return
	
	_update_vision_position()
	if gunner.has_gun():
		if _spots_enemy():
			_aim()
			if _can_shoot_enemy():
				_stop()
				_shoot()
			else:
				_move_to_enemy()
			_find_new_enemy_if_dead()
		else:
			_plan_path_to_advance()
			_aim_foward()
	else:
		if not FollowPath.path or not gun_located:
			_locate_gun()
			_plan_path_to_gun()
		else:
			_stop_if_got_gun()

func _update_vision_position():
	if _target_enemy:
		var target_position = _target_enemy.position
		var to_target = target_position - global_position
		$Vision.global_position = global_position + to_target * target_weight
	else:
		$Vision.position = Vector2()

func _plan_path_to_advance():
	if FollowPath.path: return
	
	if team.team_name == Const.TEAM_RED:
		if AICenter.get_distance_to_red_advance(global_position) > distance_threshold: 
			FollowPath.path = AICenter.get_path_to_red_advance(global_position)
	else:
		if AICenter.get_distance_to_blue_advance(global_position) > distance_threshold: 
			FollowPath.path = AICenter.get_path_to_blue_advance(global_position)

func _aim_foward():
	gunner.aim(global_position + gunner.velocity * 100)

func _spots_enemy():
	if _target_enemy:
		return true
	spotted_enemies = $Vision.get_overlapping_bodies()
	return spotted_enemies.size() > 0

func _can_shoot_enemy():
	if not _target_enemy: return false
	
	$RayCast.cast_to = to_local(_target_enemy.position)
	var collider = $RayCast.get_collider()
	if collider:
		var collider_parent = collider.get_parent()
#		print('Collider: %s - Parent: %s - Target: %s\n' % [collider.name, collider_parent.name, _target_enemy.name])
#		return collider.get_parent() == _target_enemy
		return not collider_parent is Wall
	return false

func _move_to_enemy():
	if not _target_enemy: return
	
	var new_path = AICenter.get_path_between(global_position, _target_enemy.position)
	FollowPath.path = new_path

func _stop():
	FollowPath.path = null

func _aim():
	_find_target()
	if _target_enemy:
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

func _find_new_enemy_if_dead():
	if _target_enemy and _target_enemy.dead:
		_target_enemy = null

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