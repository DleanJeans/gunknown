extends Node

const GUNNERS = 'Gunners'
const GUN_SPAWNERS = 'GunSpawners'

func get_nodes(group:String):
	return get_tree().get_nodes_in_group(group)