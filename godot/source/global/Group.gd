extends Node

const GUNNERS = 'Gunners'
const GUN_SPAWNERS = 'GunSpawners'
const SPAWN_ZONES = 'SpawnZones'
const INVISIBLE_WALLS = 'InvisibleWalls'

func get_nodes(group:String):
	return get_tree().get_nodes_in_group(group)