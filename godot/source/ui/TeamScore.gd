tool
extends Control

export(String, 'Red', 'Blue') var team setget set_team
export(bool) var flipped = false setget set_flipped
export(int, 0, 40) var score = 0 setget set_score

func set_score(value):
	score = value
	
	if is_inside_tree():
		_update_display()

func _ready():
	_update_display()
	_update_fill_mode()
	_update_tint()

func _update_display():
	$ProgressBar.value = score
	$Label.text = str(score)

func set_flipped(value):
	flipped = value
	
	if Engine.editor_hint:
		_update_fill_mode()

func _update_fill_mode():
	$ProgressBar.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT \
	if (flipped) else TextureProgress.FILL_LEFT_TO_RIGHT

func set_team(value):
	team = value
	
	if Engine.editor_hint:
		_update_tint()

func _update_tint():
	var tint_under
	var tint_progress
	
	if team == 'Red':
		tint_progress = Const.RED
		tint_under = Const.RED_UNDER
	else:
		tint_progress = Const.BLUE
		tint_under = Const.BLUE_UNDER
	
	$ProgressBar.tint_progress = tint_progress
	$ProgressBar.tint_under = tint_under