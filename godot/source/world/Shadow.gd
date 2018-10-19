tool
extends Node2D

export(float) var width = 50 setget set_width
export(float) var height = 20 setget set_height
export(float) var length = 20 setget set_length

export(Color) var color = Color(0, 0, 0, 0.25)

func set_width(new_width):
	width = new_width
	update()

func set_height(new_height):
	height = new_height
	update()

func set_length(new_length):
	length = new_length
	update()

func _draw():
	var points = [
		Vector2(),
		Vector2(-width * 0.5, 0),
		Vector2(-width * 0.5, -height),
		Vector2(-width * 0.5 - length, -height + length),
		Vector2(-width * 0.5 - length, length),
		Vector2(width * 0.5 - length, length),
		Vector2(width * 0.5, 0)
	]
	
	draw_polygon(points, _color_array(points))

func _color_array(points:PoolVector2Array) -> PoolColorArray:
	var num = points.size()
	var colors = []
	
	for i in range(num):
		colors.append(color)
	
	return colors