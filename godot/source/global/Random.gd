extends Node

var current_seed

func _ready():
	random_seed()

func random_seed():
	randomize()
	current_seed = randi()
	seed(current_seed)

func simplex2_seed_time(seed_offset:int = 0):
	var time = OS.get_ticks_msec()
	return Simplex.simplex2(current_seed + seed_offset, time)

func simplex3_seed_vector2(position:Vector2):
	return Simplex.simplex3(current_seed, position.x, position.y)