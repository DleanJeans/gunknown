extends Node2D

onready var gunner:Gunner = get_parent()
onready var FollowPath = $Steering/FollowPath

var team:TeamTag
var AICenter:AICenter
var gun_located = false

var spotted_enemies = []
var target_enemy:Gunner

func _ready():
	AICenter = GameData.get_data('AICenter')
	yield(get_tree(), 'idle_frame')
	team = gunner.get_node('Team')
	$Vision.collision_mask = team.enemy_layer

func _process(delta):
	if gunner.has_gun():
		_plan_path_to_advance()
		if _spots_enemy():
			_aim()
			_shoot()
		else:
			_advance()
	else:
		if not gun_located:
			_locate_gun()
			_plan_path_to_gun()
		else:
			_move_to_gun()

func _plan_path_to_advance():
	if not FollowPath.path:
		FollowPath.path = AICenter.get_path_to_center(global_position)

func _advance():
	var steering = FollowPath.get_steering()
	gunner.move_towards(steering)
	gunner.aim(global_position + steering * 100)

func _spots_enemy():
	spotted_enemies = $Vision.get_overlapping_bodies()
	return spotted_enemies.size() > 0

func _aim():
	target_enemy = _get_enemy()
	if target_enemy:
		gunner.aim(target_enemy.position - Vector2(0, 40))

func _get_enemy():
	var closest_enemy = null
	var closest_distance = INF
	
	for enemy in spotted_enemies:
		if enemy.dead: continue
		
		var distance = global_position.distance_squared_to(enemy.position)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	
	return closest_enemy

func _shoot():
	gunner.shoot()

var _closest

func _locate_gun():
	var gun_spawners:Array = Group.get_nodes(Group.GUN_SPAWNERS)
	var closest = { 'distance':INF, 'position':Vector2() }
	var found = false
	_closest = null
	
	for spawner in gun_spawners:
		if not spawner.has_gun(): continue
		found = true
		
		var distance = global_position.distance_squared_to(spawner.position)
		if distance < closest.distance:
			closest.spawner = spawner
			closest.distance = distance
			closest.position = spawner.position
	
	if found:
		_closest = closest

func _plan_path_to_gun():
	if not _closest: return
	
	FollowPath.path = AICenter.get_path_between(global_position, _closest.position)
	gun_located = true

func _move_to_gun():
	var steering = FollowPath.get_steering()
	gunner.move_towards(steering)
	if FollowPath.arrived or not _closest.spawner.has_gun():
		gun_located = false