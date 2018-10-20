class_name Seek
extends Node2D

onready var gunner:Gunner = $'../../..'

var target_position:Vector2

func _ready():
	target_position = global_position

func get_steering():
	if not target_position: return
	
	var direction = target_position - global_position
	direction = direction.normalized()
	
	return direction