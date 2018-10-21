class_name Winning
extends Node2D

signal winner_announced(winner)

onready var MatchTimer:MatchTimer = $'../MatchTimer'
onready var Teaming:Teaming = $'../Teaming'

var announced = false

func _ready():
	Teaming.connect('score_changed', self, '_check_for_winner')
	MatchTimer.connect('match_over', self, '_announce_winner')

func _check_for_winner():
	var winner_team
	if Teaming.blue_score >= Const.MAX_SCORE:
		winner_team = Const.TEAM_BLUE
	elif Teaming.red_score >= Const.MAX_SCORE:
		winner_team = Const.TEAM_RED
	
	if winner_team:
		emit_signal('winner_announced', winner_team)
		announced = true
	elif MatchTimer.match_over:
		_announce_winner()

func _announce_winner():
	var winner_team
	if Teaming.blue_score > Teaming.red_score:
		winner_team = Const.TEAM_BLUE
	elif Teaming.red_score > Teaming.blue_score:
		winner_team = Const.TEAM_RED
	
	if winner_team:
		emit_signal('winner_announced', winner_team)
		announced = true