extends Node2D

export(NodePath) var player_path

onready var player:Gunner = get_node(player_path)