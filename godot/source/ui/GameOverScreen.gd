extends Control

export(PackedScene) var main_menu:PackedScene

func show():
	.show()
	get_tree().paused = true
	$Buttons/MainMenu.visible = main_menu != null

func _on_MainMenu_pressed():
	get_tree().change_scene_to(main_menu)

func _on_PlayAgain_pressed():
	get_tree().reload_current_scene()

func _exit_tree():
	get_tree().paused = false