extends Node2D

func _ready():
	yield(get_tree(), 'idle_frame')
	
	assign_team_blue(get_parent().player)
	
	for zone in Group.get_nodes(Group.SPANW_ZONES):
		zone.connect('spawned', self, '_tag_new_gunner', [zone])

func _tag_new_gunner(gunner:Gunner, zone:SpawnZone):
	match zone.team:
		Const.TEAM_RED: assign_team_red(gunner)
		Const.TEAM_BLUE: assign_team_blue(gunner)

func assign_team_red(gunner:Gunner):
	var team_red = $TeamRed.duplicate()
	team_red.name = 'Team'
	gunner.add_child(team_red)

func assign_team_blue(gunner:Gunner):
	var team_blue = $TeamBlue.duplicate()
	team_blue.name = 'Team'
	gunner.add_child(team_blue)
