class_name MatchTimer
extends Node2D

signal ticked
signal match_over

export(float) var minutes = 5

onready var time_left = int(minutes * 60)

var timeouts = 0

func _on_Timer_timeout():
	timeouts += 1
	
	if timeouts == 1:
		get_tree().paused = false
		$Timer.start(time_left)
		
		while $Timer.time_left > 0:
			time_left = int($Timer.time_left)
			yield(get_tree().create_timer(0.5, false), 'timeout')
			emit_signal('ticked')
	else:
		emit_signal('match_over')