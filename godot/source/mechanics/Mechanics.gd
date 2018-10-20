extends Node2D

export(NodePath) var world_path = '../World'
export(NodePath) var player_path

var world
var player

func _enter_tree():
	world = get_node(world_path)
	player = get_node(player_path)
