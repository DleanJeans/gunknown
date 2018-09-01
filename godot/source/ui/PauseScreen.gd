extends Control

export(PackedScene) var title_screen_path:PackedScene

signal paused
signal unpaused
signal unpausing

export(bool) var pause_when_lost_focus = false

func pause():
	if game_is_paused():
		return
	
	show()
	$AnimationPlayer.play("Pause")
	get_tree().paused = true
	
	emit_signal("paused")

func unpause():
	if not game_is_paused():
		return
	
	emit_signal("unpausing")
	
	$AnimationPlayer.play_backwards("Pause")
	get_tree().paused = false
	yield($AnimationPlayer, "animation_finished")
	hide()
	
	emit_signal("unpaused")

func game_is_paused():
	return get_tree().paused

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if visible:
			unpause()
		else: pause()

func _notification(what):
	if not pause_when_lost_focus: return
	
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			pause()
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			unpause()

func restart_game():
	unpause()
	get_tree().reload_current_scene()

func quit_to_title():
	unpause()
	get_tree().change_scene("res://source/TitleScreen.tscn")