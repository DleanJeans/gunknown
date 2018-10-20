class_name AICenter
extends Node2D

var cached_path

func _ready():
	GameData.set_data('AICenter', self)

func get_path_between(from:Vector2, to:Vector2):
	return $Navigation.get_simple_path(from, to)

func get_distance_between(from:Vector2, to:Vector2):
	cached_path = get_path_between(from, to)
	
	var total_distance = 0
	for i in range(cached_path.size()):
		if i + 1 >= cached_path.size(): break
		
		var point1:Vector2 = cached_path[i]
		var point2:Vector2 = cached_path[i + 1]
		var distance = point1.distance_squared_to(point2)
		total_distance += distance
	
	return total_distance

func get_distance_to_center(from:Vector2):
	return get_distance_between(from, $Navigation/Center.global_position)

func get_path_to_center(from:Vector2):
	return get_path_between(from, $Navigation/Center.global_position)