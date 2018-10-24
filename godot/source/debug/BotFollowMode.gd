extends Node2D

export(bool) var enabled = false

#export(NodePath) var node_path
#onready var node = get_node(node_path)

export(NodePath) var spawn_zone_path
onready var spawn_zone = get_node(spawn_zone_path)

export(NodePath) var camera_director_path
onready var camera_director = get_node(camera_director_path)

func _ready():
	spawn_zone.connect('spawned_all', self, '_follow_bot')

func _follow_bot():
	if not enabled: 
		queue_free()
		return
	
	yield(get_tree(), 'idle_frame')
	
	camera_director.queue_free()
	
	var gunner:Gunner = GameData.get_data('player')
	print('Following: %s' % gunner.name)
	
	var brain = Scenes.Brain.instance()
	var camera = $Camera
	var vision = brain.get_node('Vision')
	
	remove_child(camera)
	vision.add_child(camera)
	vision.show()
	
	gunner.add_child(brain)