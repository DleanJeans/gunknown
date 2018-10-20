extends Node2D

onready var gunner:Gunner = $'../..'

func _physics_process(delta):
	if $FollowPath.path:
		var steering = $FollowPath.get_steering()
		gunner.move_towards(steering)
	
#	var separation = $Separation.get_steering()
#	gunner.velocity += separation