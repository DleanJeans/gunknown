class_name Wall
extends Node2D
tool

const DEFAULT_WIDTH = 100
const TOP_SIZE = 100

export(float) var width = 100 setget set_width
export(float) var height = 100 setget set_height
export(float) var body_for_bullet_offset = 50 setget set_body_offset

func _ready():
	_update_width()
	_update_height()
	_update_body_offset()

func set_width(new_width):
	width = new_width
	
	if Engine.editor_hint:
		_update_width()

func _update_width():
	$Shadow.width = width
	
	var scale_x = width / DEFAULT_WIDTH
	$Front.scale.x = scale_x
	$Top.scale.x = scale_x
	$BodyForGunner.scale.x = scale_x
	$BodyForBullet.scale.x = scale_x

func set_height(new_height):
	height = new_height
	
	if Engine.editor_hint:
		_update_height()

func _update_height():
	$Shadow.height = height
	
	var scale_y = height / TOP_SIZE
	$Top.scale.y = scale_y
	$Top.position.y = -height * 0.5 - 50
	$BodyForGunner.scale.y = scale_y
	$BodyForBullet.scale.y = scale_y - 0.25
	$BodyForGunner.position.y = -height * 0.5 + 50
	$BodyForBullet.position.y = -height * 0.5 + 50 - body_for_bullet_offset

func set_body_offset(new_offset):
	body_for_bullet_offset = new_offset
	
	if Engine.editor_hint:
		_update_body_offset()

func _update_body_offset():
	$BodyForBullet.position.y = -height * 0.5 + 50 - body_for_bullet_offset