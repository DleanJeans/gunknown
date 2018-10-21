extends Node2D

export(float) var duration = 3
export(float) var time_scale = 0.15

onready var winning:Winning = $'../Winning'
onready var match_timer = $'../MatchTimer'

func _ready():
	Engine.time_scale = 1
	winning.connect('winner_announced', self, '_start_slomo')
#	match_timer.connect('match_over', self, '_start_slomo')

func _start_slomo(ignored):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(duration), 'timeout')
	Engine.time_scale = 1