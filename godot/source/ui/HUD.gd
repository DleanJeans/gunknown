extends Control

export(NodePath) var teaming_path
export(NodePath) var match_timer_path

onready var teaming:Teaming = get_node(teaming_path)
onready var match_timer:MatchTimer = get_node(match_timer_path)

var player

func set_player(player):
	self.player = player
	$AvatarHealth/HealthBar.set_player(player)
	$AmmoCount.set_player(player)

func _ready():
	$MatchInfo.set_teaming(teaming)
	$MatchInfo.set_match_timer(match_timer)

func _process(delta):
	$AvatarHealth.visible = not player.dead