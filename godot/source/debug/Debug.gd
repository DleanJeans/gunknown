extends Node2D

export(bool) var enable = true

func _enter_tree():
	if not OS.is_debug_build() or not enable:
		queue_free()