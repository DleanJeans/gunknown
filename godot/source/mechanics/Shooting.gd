extends Node2D

func _ready():
	yield(get_tree(), 'idle_frame')
	
	for spawner in Group.get_nodes(Group.GUN_SPAWNERS):
		spawner.connect('spawned_gun', self, '_connect_gun_shot')

func _connect_gun_shot(gun:Gun):
	gun.connect('shot', self, '_add_bullet_to_world')

func _add_bullet_to_world(bullet):
	get_parent().world.add_child(bullet)