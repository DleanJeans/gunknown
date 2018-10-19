extends Node

var current_seed:int

func _ready():
	_randomize_seed()

func _randomize_seed():
	randomize()
	current_seed = randi()
	seed(current_seed)

func get_simplex_2d_seed_time(seed_offset:int = 0):
	var frame = get_tree().get_frame()
	var offset_seed = current_seed + seed_offset
	return Simplex.simplex2(offset_seed, frame)