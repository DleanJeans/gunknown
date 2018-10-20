extends Control

export(NodePath) var winning_path

onready var winning = get_node(winning_path)

func _ready():
	winning.connect('winner_announced', self, '_display_winner')

func _display_winner(winner_team:String):
	$Team.text = '%s Team' % winner_team
	if winner_team == Const.TEAM_BLUE:
		$Team.modulate = Const.BLUE
	else: $Team.modulate = Const.RED
	show()

func show():
	.show()
	get_tree().paused = true

func _on_MainMenu_pressed():
	get_tree().change_scene('res://source/TitleScreen.tscn')

func _on_PlayAgain_pressed():
	get_tree().reload_current_scene()

func _exit_tree():
	get_tree().paused = false