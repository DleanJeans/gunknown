tool
extends Node2D

signal finished

enum AudioPlayerType {
	PLAYER,
	PLAYER_2D,
	PLAYER_3D,
}

export(AudioStream) var create_sound_player setget set_create_sound_player
export(AudioPlayerType) var player_mode = PLAYER_2D setget set_player_mode
export(bool) var enable_random_pitch = true
export(float) var random_pitch = 1.1

export(NodePath) var root_node = '..'
export(String) var play_signal = ''
export(String) var stop_signal = ''

export(bool) var free_on_finished = false

onready var root = get_node(root_node)

var current_sound

func _ready():
	if play_signal != '':
		root.connect(play_signal, self, 'play')
	if stop_signal != '':
		root.connect(stop_signal, self, 'stop')

func set_create_sound_player(sound_file):
	if not Engine.editor_hint or sound_file == null: return
	
	var player_node = _create_audio_player()
	
	if enable_random_pitch:
		var random_pitch_stream = AudioStreamRandomPitch.new()
		random_pitch_stream.audio_stream = sound_file
		random_pitch_stream.random_pitch = random_pitch
		player_node.stream = random_pitch_stream
	else:
		player_node.stream = sound_file
	
	add_child(player_node)
	player_node.owner = get_tree().edited_scene_root
	player_node.name = str(get_child_count())

func _create_audio_player():
	match player_mode:
		PLAYER: return AudioStreamPlayer.new()
		PLAYER_2D: return AudioStreamPlayer2D.new()
		PLAYER_3D: return AudioStreamPlayer3D.new()

func set_player_mode(new_mode):
	player_mode = new_mode
	if not Engine.editor_hint: return
	_change_audio_players_type()

func _change_audio_players_type():
	for player in get_children():
		var new_player = _create_audio_player()
		new_player.stream = player.stream
		new_player.name = player.name
		remove_child(player)
		player.queue_free()
		add_child(new_player)
		new_player.owner = get_tree().edited_scene_root

func play(p1=null, p2=null, p3=null, p4=null):
	var child_count = get_child_count()
	if child_count == 0: return
	
	var num = randi() % child_count
	current_sound = get_child(num)
	current_sound.play()
	
	yield(current_sound, 'finished')
	if free_on_finished:
		queue_free()
	emit_signal('finished')

func stop(p1=null, p2=null, p3=null, p4=null):
	if current_sound != null and current_sound.playing:
		current_sound.stop()