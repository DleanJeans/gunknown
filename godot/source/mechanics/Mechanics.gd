extends Node2D

export(NodePath) var world_path = '../World'
export(NodePath) var player_path

onready var world = get_node(world_path)
onready var player:Gunner = get_node(player_path)