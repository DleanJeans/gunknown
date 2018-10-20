class_name AICenter
extends Node2D

func _ready():
	GameData.set_data('AICenter', self)

func get_path_between(from:Vector2, to:Vector2):
	return $Navigation.get_simple_path(from, to)

func get_path_to_center(from:Vector2):
	return get_path_between(from, $Navigation/Center.global_position)