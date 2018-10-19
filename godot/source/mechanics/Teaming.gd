extends Node2D

func _ready():
	yield(get_tree(), 'idle_frame')
	var i = 0
	for gunner in Group.get_nodes(Group.GUNNERS):
		if i % 2 == 0:
			assign_team_blue(gunner)
		else:
			assign_team_red(gunner)
		i += 1

func assign_team_red(gunner:Gunner):
	var team_red = $TeamRed.duplicate()
	team_red.name = 'Team'
	gunner.add_child(team_red)

func assign_team_blue(gunner:Gunner):
	var team_blue = $TeamBlue.duplicate()
	team_blue.name = 'Team'
	gunner.add_child(team_blue)
