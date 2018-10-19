tool
class_name SpawnZone
extends Node2D

export(String, 'Red', 'Blue') var team setget set_team

func set_team(new_team):
	team = new_team
	
	if Engine.editor_hint:
		_update_team()

func _ready():
	_update_team()

func _update_team():
	var color = Const.RED
	var collision_mask = Const.LAYER_BLUE
	
	if team == 'Blue':
		color = Const.BLUE
		collision_mask = Const.LAYER_RED
	
	$Sprite.modulate = color
	$Blocker.collision_mask |= collision_mask