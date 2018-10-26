class_name Ellipse
extends Node2D

var center = Vector2()
var a = 2
var b = 1

func _init(a, b):
	self.a = a
	self.b = b

func compute_radius(direction:Vector2):
	var theta = direction.angle_to_point(Vector2())
	
	var sin2_theta = pow(sin(theta), 2)
	var cos2_theta = pow(cos(theta), 2)
	
	var a2 = a * a
	var b2 = b * b
	
	var denominator = sqrt(a2 * sin2_theta + b2 * cos2_theta)
	var radius = a * b / denominator
	
	return radius