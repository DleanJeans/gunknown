extends Timer
class_name SelfDestruct

func _init(time = 1):
	start(time)
	yield(self, 'timeout')
	get_parent().queue_free()