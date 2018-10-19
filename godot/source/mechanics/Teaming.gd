class_name Teaming
extends Node2D

signal score_changed

var red_score = 0
var blue_score = 0

func _ready():
	yield(get_tree(), 'idle_frame')
	
	assign_team_blue(get_parent().player)
	
	for zone in Group.get_nodes(Group.SPAWN_ZONES):
		zone.connect('spawned', self, '_tag_new_gunner', [zone])

func _tag_new_gunner(gunner:Gunner, zone:SpawnZone):
	match zone.team:
		Const.TEAM_RED: assign_team_red(gunner)
		Const.TEAM_BLUE: assign_team_blue(gunner)

func assign_team_red(gunner:Gunner):
	var team_red = $TeamRed.duplicate()
	team_red.name = 'Team'
	gunner.add_child(team_red)
	
	gunner.connect('died', self, '_add_blue_score')

func assign_team_blue(gunner:Gunner):
	var team_blue = $TeamBlue.duplicate()
	team_blue.name = 'Team'
	gunner.add_child(team_blue)
	
	gunner.connect('died', self, '_add_red_score')

func _add_blue_score():
	blue_score += 1
	emit_signal('score_changed')

func _add_red_score():
	red_score += 1
	emit_signal('score_changed')