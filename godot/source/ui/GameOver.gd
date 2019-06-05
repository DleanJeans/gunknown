extends Control

export(PackedScene) var main_menu:PackedScene

func show():
	.show()
	$AnimationPlayer.play('show')
	get_tree().paused = true
	$Buttons/MainMenu.visible = main_menu != null

func _on_MainMenu_pressed():
	Transition.change_scene_to(main_menu)

func _on_PlayAgain_pressed():
	Transition.reload_current_scene()

func _exit_tree():
	get_tree().paused = false