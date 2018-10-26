extends Node2D

export(bool) var enabled = false setget set_enabled

export(NodePath) var spawn_zone_path
onready var spawn_zone = get_node(spawn_zone_path)

export(NodePath) var camera_director_path
onready var camera_director = get_node(camera_director_path)

func set_enabled(value):
	enabled = value
	
	if not is_inside_tree(): return
	if enabled:
		_follow_bot()
	else:
		_unfollow_bot()

func _ready():
	if enabled:
		spawn_zone.connect('spawned_all', self, '_follow_bot')

func _follow_bot():
	yield(get_tree(), 'idle_frame')
	
	camera_director.enabled = false
	
	var gunner:Gunner = GameData.get_data('player')
	print('Following: %s' % gunner.name)
	
	var brain = Scenes.Brain.instance()
	var camera = $Camera
	var vision = brain.get_node('Vision')
	
	gunner.add_child(brain)
	
	remove_child(camera)
	vision.add_child(camera)
	camera.make_current()
	vision.show()
#	gunner.get_vision().make_current()

func _unfollow_bot():
	camera_director.enabled = true
	camera_director.get_node('Vision').make_current()
	
	var gunner:Gunner = GameData.get_data('player')
	print('Unfollowing: %s' % gunner.name)
	
	var brain = gunner.get_node('Brain')
	var vision = brain.get_node('Vision')
	var camera = vision.get_node('Camera')
	
	brain.queue_free()
	vision.remove_child(camera)
	add_child(camera)