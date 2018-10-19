tool
class_name SpawnZone
extends Node2D

signal spawned(gunner)

export(String, 'Red', 'Blue') var team setget set_team

var rect:Rect2

func set_team(new_team):
	team = new_team
	
	if Engine.editor_hint:
		_update_team()

func _ready():
	_update_team()
	
	var rect_size = scale * 100 * 0.8
	rect = Rect2(position - rect_size * 0.5, rect_size)
	
	if team == Const.TEAM_BLUE:
		_spawn_gunners(4)
	else:
		_spawn_gunners(5)

func _update_team():
	var color = Const.RED
	var collision_mask = Const.LAYER_BLUE
	
	if team == 'Blue':
		color = Const.BLUE
		collision_mask = Const.LAYER_RED
	
	$Sprite.modulate = color
	$Blocker.collision_mask = collision_mask

func _spawn_gunners(num:int = 1):
	yield(get_tree(), 'idle_frame')
	
	var world = get_parent()
	
	for i in range(num):
		var gunner = Scenes.Gunner.instance()
		var random_position = Vector2()
		random_position.x = rand_range(rect.position.x, rect.end.x)
		random_position.y = rand_range(rect.position.y, rect.end.y)
		
		gunner.position = random_position
		world.add_child(gunner)
		
		emit_signal('spawned', gunner)