extends Control

signal paused
signal unpaused
signal unpausing

export(PackedScene) var title_scene
export(bool) var pause_when_lost_focus = true
export(bool) var countdown_before_resume = true

func _ready():
	hide()
	if not title_scene:
		$Buttons/Quit.hide()

func restart_game():
	unpause()
	Transition.reload_current_scene()

func quit_to_title():
	unpause()
	if title_scene:
		Transition.change_scene_to(title_scene)

func pause():
	if game_is_paused():
		return
	
	show()
	$AnimationPlayer.play('fade_panel')
	yield($AnimationPlayer, 'animation_finished')
	$AnimationPlayer.play('show_buttons')
	get_tree().paused = true
	
	emit_signal('paused')

func unpause():
	if not game_is_paused():
		return
	
	emit_signal('unpausing')
	
	$AnimationPlayer.play_backwards('show_buttons')
	yield($AnimationPlayer, 'animation_finished')
	
	if countdown_before_resume:
		$ResumeTimer.start()
		$ResumeLabel.show()
		yield($ResumeTimer, 'timeout')
		
	get_tree().paused = false
	
	$AnimationPlayer.play_backwards('fade_panel')
	$ResumeLabel.hide()
	yield($AnimationPlayer, 'animation_finished')
	hide()
	emit_signal('unpaused')

func game_is_paused():
	return get_tree().paused

func _process(delta):
	var time_left:float = $ResumeTimer.time_left
	if time_left > 0:
		$ResumeLabel.text = str(ceil(time_left * 1.5))

	if Input.is_action_just_pressed('ui_cancel'):
		if time_left > 0: return
		if visible:
			unpause()
		else:
			pause()

func _notification(what):
	if not pause_when_lost_focus: return
	
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			pause()