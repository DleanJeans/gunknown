tool
extends Control

export(int) var time_left = 300 setget set_time_left

func set_time_left(value):
	time_left = value
	
	if is_inside_tree():
		print(time_left)
		
		var minutes = time_left / 60
		var seconds = time_left % 60
		
		if seconds < 10:
			seconds = '0%s' % seconds
		
		$Label.text = '%s:%s' % [minutes, seconds]