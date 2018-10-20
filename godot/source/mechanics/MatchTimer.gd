class_name MatchTimer
extends Node2D

signal ticked
signal match_began
signal match_over

export(float) var prematch_countdown = 3
export(float) var minutes = 5

onready var match_length = int(minutes * 60)

var time_left = 0
var timeouts = 0

func _ready():
	$Timer.start(prematch_countdown)
	
	while $Timer.time_left > 0:
		time_left = int($Timer.time_left)
		emit_signal('ticked')
		yield(get_tree().create_timer(0.5), 'timeout')

func _on_Timer_timeout():
	timeouts += 1
	
	if timeouts == 1:
		$Timer.start(match_length)
		emit_signal('match_began')
	else:
		emit_signal('match_over')