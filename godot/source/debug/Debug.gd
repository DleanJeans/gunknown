extends Node2D

export(NodePath) var player_path

onready var player:Gunner = get_node(player_path)

export(bool) var enable = true

func _enter_tree():
	if not OS.is_debug_build() or not enable:
		queue_free()