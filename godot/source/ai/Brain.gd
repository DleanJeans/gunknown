extends Node2D

export(float) var aim_ahead = 100

onready var gunner:Gunner = get_parent()
onready var FollowPath = $Steering/FollowPath

var team:TeamTag
var AICenter:AICenter
var gun_located = false

var _target_enemy:Gunner

var target_weight = 0.35
var distance_threshold = 50 * 50

func _ready():
	set_process(false)
	AICenter = GameData.get_data('AICenter')
	
	yield(get_tree(), 'idle_frame')
	set_process(true)
	
	team = gunner.get_node('Team')
	$Vision.collision_mask = team.enemy_layer
	$RayCast.position = gunner.get_node('GunPosition').position
	
	gunner.connect('died', self, '_reset')
	
	_add_all_team_to_raycast_exception()

func _add_all_team_to_raycast_exception():
	var teammates = Group.get_nodes(team.team_name)
	for gunner in teammates:
		$RayCast.add_exception(gunner)
		$RayCast.add_exception(gunner.get_node('Hitbox'))

func _reset():
	FollowPath.path = null
	_target_enemy = null

func _process(delta):
	if gunner.dead or not AICenter._has_match_began(): return
	
	_update_vision_position()
	if gunner.has_gun():
		if _spots_enemy():
			_update_enemy_target()
			_aim_at_target()
			if _can_shoot_target():
				_stop_moving()
				_shoot()
			elif not _can_see_target():
				_untarget()
			else:
				_move_to_enemy()
			_remove_path_if_target_dead()
		else:
			_follow_path_to_advance()
			_aim_at_target_foward()
	else:
		_locate_gun()
		_follow_path_to_gun()

func _untarget():
	_target_enemy = null

func _remove_path_if_target_dead():
	if _target_enemy and _target_enemy.dead:
		FollowPath.path = null

func _update_vision_position():
	var gunner_vision:Camera2D = gunner.get_vision()
	var target_position
	
	if _target_enemy:
		target_position = _target_enemy.position
	else:
		target_position = global_position + gunner.velocity.normalized() * aim_ahead
	
	if target_position:
		var to_target:Vector2 = target_position - global_position
		var limit = Ellipse.new(2000, 550).compute_radius(to_target)
		to_target = to_target.clamped(limit)
		
		$Vision.global_position = global_position + to_target * target_weight
	else:
		$Vision.position = Vector2()
	
	var size = $Vision/Shape.shape.extents * 2
	var pos = global_position - size * 0.5
	var rect = Rect2(pos, size)
	
	var left_difference = gunner_vision.limit_left - rect.position.x
	var right_difference =  gunner_vision.limit_right - rect.end.x
	var top_difference =  gunner_vision.limit_top - rect.position.y
	var bottom_difference =  gunner_vision.limit_bottom - rect.end.y
	
	if left_difference > 0:
		$Vision.position.x -= left_difference
	elif right_difference < 0:
		$Vision.position.x += right_difference
	if top_difference > 0:
		$Vision.position.y += top_difference
	elif bottom_difference < 0:
		$Vision.position.y += bottom_difference

func _follow_path_to_advance():
	if FollowPath.path: return
	
	if AICenter.get_distance_to_center(global_position) > distance_threshold:
			FollowPath.path = AICenter.get_path_to_center(global_position)

func _aim_at_target_foward():
	gunner.aim(global_position + gunner.velocity * aim_ahead)

func _spots_enemy():
	if _target_enemy:
		return true
	var spotted_enemies = $Vision.get_overlapping_bodies()
	return spotted_enemies.size() > 0

func _can_shoot_target():
	if not _target_enemy: return false
	
	var raycast_hit_enemy = _raycast_hit_enemy()
	return raycast_hit_enemy

func _raycast_hit_enemy():
	var collider_parent = _get_raycast_collider_parent(_target_enemy)
	if collider_parent:
		return not collider_parent is Wall
	return false

func _raycast_to(enemy):
	var collider_parent = _get_raycast_collider_parent(enemy)
	return collider_parent == enemy

func _get_raycast_collider_parent(enemy):
	$RayCast.cast_to = to_local(enemy.position)
	$RayCast.force_raycast_update()
	
	var collider = $RayCast.get_collider()
	if collider:
		return collider.get_parent()
	return

func _can_see_target():
	return _can_see(_target_enemy)

func _can_see(body):
	return body in $Vision.get_overlapping_bodies()

func _move_to_enemy():
	if not _target_enemy: return
	
	var new_path = AICenter.get_path_between(global_position, _target_enemy.position)
	FollowPath.path = new_path

func _stop_moving():
	FollowPath.path = null

func _aim_at_target():
	if _target_enemy:
		gunner.aim(_target_enemy.position + gunner.get_node('Hitbox').position)

func _update_enemy_target():
	_target_enemy = $TargetSelector.find_best_target()
	return
	
	_target_enemy = null
	
	var closest_enemy
	var closest_distance = INF
	
	for enemy in $Memory.enemies_seen:
		if enemy.dead or not _can_see(enemy): continue
		
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
	_target_spawner = null
	_path_to_spawner = null
	
	var closest_gun = _find_closest_gun()
	
	if closest_gun.distance != INF:
		_target_spawner = closest_gun.spawner
		_path_to_spawner = closest_gun.path

func _find_closest_gun():
	return _find_closest_gun_from(global_position)

func _find_closest_gun_from(point):
	var gun_spawners:Array = Group.get_nodes(Group.GUN_SPAWNERS)
	var closest = { 'distance':INF }
	
	for spawner in gun_spawners:
		if not spawner.has_gun(): continue
		
		var distance = AICenter.get_distance_between(point, spawner.position)
		if distance < closest.distance:
			closest.spawner = spawner
			closest.path = AICenter.cached_path
			closest.distance = distance
	
	return closest

func _follow_path_to_gun():
	if not _target_spawner: return
	
	FollowPath.path = _path_to_spawner