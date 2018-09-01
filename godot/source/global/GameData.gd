extends Node

var data = {}

func set_data(name, value):
	data[name] = value

func get_data(name):
	if data.has(name):
		return data[name]
	return null