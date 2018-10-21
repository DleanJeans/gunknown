#extends CanvasLayer
extends Line2D

onready var bullet = get_parent()
onready var bullet_ref = weakref(bullet)

func _ready():
	bullet.connect('tree_exiting', $AnimationPlayer, 'play', ['Fade'])
	yield($AnimationPlayer, 'animation_finished')
	queue_free()

func _process(delta):
	if not bullet_ref.get_ref(): return
	var point = bullet.position
	add_point(point)