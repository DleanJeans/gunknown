extends Node2D

export(String, 'Red', 'Blue') var team_name = 'Red'

var collision_layer
var color
var group

func _ready():
	_setup_data()
	_setup_gunner()

func _setup_data():
	match team_name:
		'Red':
			collision_layer = Const.LAYER_RED
			color = Const.RED
			group = Const.TEAM_RED
		'Blue':
			collision_layer = Const.LAYER_BLUE
			color = Const.BLUE
			group = Const.TEAM_BLUE

func _setup_gunner():
	if not get_parent() is Gunner: return
	
	var gunner:Gunner = get_parent()
	gunner.collision_layer |= collision_layer
	gunner.add_to_group(group)
	
	var team_circle = Scenes.TeamCircle.instance()
	team_circle.modulate = color
	gunner.add_child(team_circle)

func same(gunner:Gunner):
	var team = gunner.get_node('Team')
	return team.team_name == self.team_name