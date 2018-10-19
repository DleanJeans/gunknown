extends Node

const GUNNERS = 'Gunners'
const GUN_SPAWNERS = 'GunSpawners'
const SPANW_ZONES = 'SpawnZones'

func get_nodes(group:String):
	return get_tree().get_nodes_in_group(group)