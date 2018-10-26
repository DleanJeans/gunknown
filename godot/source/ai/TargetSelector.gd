extends Node2D

export(int) var criterium_score = 100
export(bool) var enable_drawing_debug_score = false
export(Vector2) var debug_score_offset = Vector2(50, -100)
export(Font) var debug_font

onready var memory = $'../Memory'

var _candidates:Array

var _min_distance:float
var _max_distance:float
var _distance_map:Dictionary

var _min_gun_distance:float
var _max_gun_distance:float
var _gun_distance_map:Dictionary

var _score_map = {}

func find_best_target():
	_candidates = memory.enemies_seen
	
	if _candidates.size() == 0:
		return
	elif _candidates.size() == 1:
		return _candidates[0]

	_compute_distance_range()
#	_compute_gun_distance_range()
	_compute_each_enemy_score()
	_draw_score_for_debug()
	
	var best_target = _get_highest_scored_enemy()
	
	return best_target

func _compute_distance_range():
	if get_parent().gunner.has_meta('is_player'):
		pass
	
	_min_distance = INF
	_max_distance = -INF
	_distance_map = {}

	for enemy in _candidates:
		var distance = get_parent().AICenter.get_distance_between(global_position, enemy.position)
		
		if distance < _min_distance:
			_min_distance = distance
		if distance > _max_distance:
			_max_distance = distance
		
		_distance_map[enemy.name] = distance

func _compute_gun_distance_range():
	_min_gun_distance = INF
	_max_gun_distance = -INF

	_gun_distance_map = {}

	for enemy in _candidates:
		var closest_gun = get_parent()._find_closest_gun_from(enemy.position)
		var distance = closest_gun.distance
		
		if distance < _min_gun_distance:
			_min_gun_distance = distance
		elif distance > _max_gun_distance:
			_max_gun_distance = distance
		
		_gun_distance_map[enemy.name] = distance

func _compute_each_enemy_score():
	var best_candidate
	var best_score = 0
	_score_map = {}

	for enemy in _candidates:
		var score_dict = {}
		
#		score_dict.has_gun = 0
#		if enemy.has_gun():
#			score_dict.has_gun = criterium_score
		
		score_dict.shootable = 0
		if get_parent()._raycast_to(enemy):
			score_dict.shootable = criterium_score * 0.5

		var distance = _distance_map[enemy.name]
		score_dict.distance = range_lerp(distance, _min_distance, _max_distance, criterium_score, 0)
		score_dict.distance = round(score_dict.distance)
		
		if get_parent().gunner.has_meta('is_player') and score_dict.distance < 0:
			pass
		
#		var closest_gun_distance = _gun_distance_map[enemy.name]
#		score_dict.gun_distance = range_lerp(closest_gun_distance, _min_gun_distance, _max_gun_distance, criterium_score, 0)
		
		var total_score = 0
		for key in score_dict.keys():
			var score = score_dict[key]
			total_score += score
		
		score_dict.total = total_score
		_score_map[enemy.name] = score_dict

func _draw_score_for_debug():
	update()

func _get_highest_scored_enemy():
	var best_enemy
	var best_score = -INF
	
	for enemy in _candidates:
		var score_dict = _score_map[enemy.name]
		var total_score = score_dict.total
		
		if total_score > best_score:
			best_score = total_score
			best_enemy = enemy
	
	return best_enemy

func _draw():
	var gunner_is_player = get_parent().gunner.has_meta('is_player')
	var should_draw = enable_drawing_debug_score and gunner_is_player
	if not should_draw: return
	
	if get_parent().gunner.dead:
		for label in get_children():
			label.hide()
	
	for enemy in _candidates:
		var label
		if has_node(enemy.name):
			label = get_node(enemy.name)
		else:
			label = Scenes.DebugLabel.instance()
			label.name = enemy.name
			label.rect_scale *= 2
#			label.add_font_override('custom_fonts/font', debug_font)
			add_child(label)
		
		if enemy.dead:
			label.hide()
			return
		else: label.show()
		
		var score_dict = _score_map[enemy.name]
		var draw_position = to_local(enemy.position) + debug_score_offset
		var output_text = enemy.name 
		output_text += '\nScore Total: %s\n' % score_dict.total
		output_text += ' - Distance: %s\n' % score_dict.distance
#		output_text += ' - Gun Dist: %s\n' % score_dict.gun_distance
		output_text += ' - Shootabl: %s\n' % score_dict.shootable
#		output_text += ' - Have Gun: %s\n' % score_dict.has_gun
		
		label.text = output_text
		label.rect_position = draw_position