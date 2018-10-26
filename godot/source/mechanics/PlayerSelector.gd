extends Node2D

export(NodePath) var spawn_zone_path
export(NodePath) var camera_director_path
export(NodePath) var hud_path

onready var spawn_zone:SpawnZone = get_node(spawn_zone_path)
onready var camera_director = get_node(camera_director_path)
onready var hud = get_node(hud_path)
onready var player_control = $'../PlayerControl'

func _ready():
	spawn_zone.connect('spawned_all', self, '_select_player')

func _select_player():
	var gunners = Group.get_nodes(Const.TEAM_BLUE)
	var random_index = randi() % gunners.size()
	var player:Gunner = gunners[random_index]
	
	player.get_node('Brain').free()
	player.set_meta('is_player', true)
	GameData.set_data('player', player)
	
	_set_player(player)

func _set_player(player):
	player_control.set_player(player)
	hud.set_player(player)
	camera_director.set_player(player)