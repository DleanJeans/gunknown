class_name AICenter
extends Node2D

onready var match_timer:MatchTimer = $'../Mechanics/MatchTimer'

var cached_path

func _has_match_began():
	return match_timer.match_began

func _ready():
	GameData.set_data('AICenter', self)

func get_path_between(from:Vector2, to:Vector2):
	var closest = $Navigation.get_closest_point(from)
	cached_path = Array($Navigation.get_simple_path(closest, to))
	if closest != from:
		cached_path.push_front(from)
	return cached_path

func get_distance_between(from:Vector2, to:Vector2):
	var path = get_path_between(from, to)
	
	var total_distance = 0
	for i in range(path.size()):
		if i + 1 >= path.size(): break
		
		var point1:Vector2 = path[i]
		var point2:Vector2 = path[i + 1]
		var distance = point1.distance_squared_to(point2)
		total_distance += distance
	
	return total_distance

func get_distance_to_center(from:Vector2):
	return get_distance_between(from, $Navigation/Center.global_position)
	
func get_path_to_center(from:Vector2):
	return get_path_between(from, $Navigation/Center.global_position)
