extends Node2D

onready var MatchTimer:MatchTimer = $'../MatchTimer'

func _ready():
	MatchTimer.connect('match_began', self, '_disable_invisible_walls')

func _disable_invisible_walls():
	for wall in Group.get_nodes(Group.INVISIBLE_WALLS):
		wall.disable()