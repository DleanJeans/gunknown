#extends CanvasLayer
extends Line2D

onready var bullet = get_parent()
onready var bullet_ref = weakref(bullet)

func _ready():
	add_point(bullet.position)
	add_point(bullet.position)
	
	bullet.connect('tree_exiting', $AnimationPlayer, 'play', ['Fade'])
	yield($AnimationPlayer, 'animation_finished')
	queue_free()

func _process(delta):
	if not bullet_ref.get_ref(): return
	points[1] = bullet.position