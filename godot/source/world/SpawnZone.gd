tool
class_name SpawnZone
extends Node2D

signal spawned(gunner)
signal spawned_all

export(String, 'Red', 'Blue') var team setget set_team

onready var world = get_parent()

var spawn_points = []

func set_team(new_team):
	team = new_team
	
	if Engine.editor_hint:
		_update_team()

func _ready():
	_update_team()
	_get_spawn_points()
	_spawn_gunners()

func _update_team():
	var color = Const.RED
	var collision_mask = Const.LAYER_BLUE
	
	if team == 'Blue':
		color = Const.BLUE
		collision_mask = Const.LAYER_RED
	
	$Sprite.modulate = color
	$Blocker.collision_mask = collision_mask

func _get_spawn_points():
	for child in get_children():
		if child is Position2D:
			spawn_points.append(child.global_position)

func _spawn_gunners():
	yield(get_tree(), 'idle_frame') # do not remove
	
	for position in spawn_points:
		_spawn(position)
	
	emit_signal('spawned_all')

func _spawn(position:Vector2):
	var gunner = Scenes.Gunner.instance()
	var brain = Scenes.Brain.instance()
	
	gunner.position = position
	
	gunner.add_child(brain)
	world.add_child(gunner, true)
	
	emit_signal('spawned', gunner)
	
	gunner.connect('died', self, '_respawn', [gunner])

export(float) var respawn_wait = 3

func _respawn(gunner):
	yield(get_tree().create_timer(respawn_wait, false), 'timeout')
	
	var spawn_point = _get_random_spawn_point()
	gunner.revive()
	gunner.position = spawn_point

func _get_random_spawn_point():
	return spawn_points[randi() % spawn_points.size()]