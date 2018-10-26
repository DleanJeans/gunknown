extends Node

export(float) var forget_time = 3

onready var vision = $'../Vision'

var enemies_seen = []

func _ready():
	vision.connect('body_entered', self, '_add_to_seen')
	vision.connect('body_exited', self, '_remove_from_seen_after_threshold')
	yield(get_tree(), 'idle_frame')
	get_parent().gunner.connect('died', self, '_clear')

func _clear():
	enemies_seen = []

func _add_to_seen(enemy):
	if enemy in enemies_seen:
		var timer:Timer = get_node(enemy.name)
		timer.stop()
	else:
		enemies_seen.append(enemy)
		
		if not has_node(enemy.name):
			var timer = Timer.new()
			timer.name = enemy.name
			timer.one_shot = true
			add_child(timer)
			timer.connect('timeout', self, '_remove_from_seen', [enemy])
			enemy.connect('died', self, '_remove_from_seen', [enemy])

func _remove_from_seen_after_threshold(enemy):
	var timer = get_node(enemy.name)
	timer.start(forget_time)

func _remove_from_seen(enemy):
	enemies_seen.erase(enemy)