extends Control

var teaming:Teaming
var match_timer:MatchTimer

func set_teaming(teaming:Teaming):
	self.teaming = teaming
	teaming.connect('score_changed', self, '_update_scores')

func set_match_timer(match_timer:MatchTimer):
	self.match_timer = match_timer
	match_timer.connect('ticked', self, '_update_time')

func _update_time():
	$Container/TimerHUD.time_left = match_timer.time_left

func _update_scores():
	$Container/RedScore.score = teaming.red_score
	$Container/BlueScore.score = teaming.blue_score
