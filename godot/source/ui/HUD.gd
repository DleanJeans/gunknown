extends Control

export(NodePath) var player_path
export(NodePath) var teaming_path
export(NodePath) var match_timer_path

onready var player:Gunner = get_node(player_path)
onready var teaming:Teaming = get_node(teaming_path)
onready var match_timer:MatchTimer = get_node(match_timer_path)

func _ready():
	$AvatarHealth/HealthBar.set_player(player)
	$AmmoCount.set_player(player)
	$MatchInfo.set_teaming(teaming)
	$MatchInfo.set_match_timer(match_timer)