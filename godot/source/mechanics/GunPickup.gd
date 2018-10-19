extends Node2D

var gunners_on_spawner = []

func _ready():
	yield(get_tree(), 'idle_frame')
	
	for spawner in Group.get_nodes(Group.GUN_SPAWNERS):
		spawner.connect('gunner_entered', self, '_on_gunner_entered', [spawner])
		spawner.connect('gunner_entered', self, '_on_gunner_exited')

func _on_gunner_entered(gunner:Gunner, spawner:GunSpawner):
	gunner.set_meta('gun_spawner', spawner)
	if not gunner.owns_gun():
		_give_gun_to_gunner(gunner, spawner)

func _give_gun_to_gunner(gunner:Gunner, spawner:GunSpawner):
	var gun = spawner.get_gun()
	gunner.receive_gun(gun)

func _on_gunner_exited(gunner:Gunner):
	gunner.set_meta('gun_spawner', null)

func _add_to_dict(gunner:Gunner, spawner:GunSpawner):
	gunners_on_spawner.append(gunner)