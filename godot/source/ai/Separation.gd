extends Node2D

export(float) var decay = 1000 * 1000

func get_steering():
	var parent_gunner = get_parent().gunner
	var gunners = $Vicinity.get_overlapping_bodies()
	if parent_gunner in gunners:
		gunners.erase(parent_gunner)
	
	var total = Vector2()
	var strength
	
	for gunner in gunners:
		var distance = global_position.distance_squared_to(gunner.position)
		strength = decay / distance
	
		var direction = global_position - parent_gunner.position
		direction = direction.normalized()
		
		total += direction * strength
	
	return total