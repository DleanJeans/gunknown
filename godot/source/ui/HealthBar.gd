extends Control

onready var HealthLeft = $MarginContainer/Container/Labels/HealthLeft
onready var ProgressBar = $MarginContainer/Container/ProgressBar

export(float) var tween_duration = 0.3

var player:Gunner
var displayed_hp = 200

func set_player(player:Gunner):
	self.player = player
	player.connect('hp_changed', self, '_update_hp')
	_update_hp()

func _update_hp():
	var hp = player.hp
	
	if $Tween.is_active():
		$Tween.stop_all()
	$Tween.interpolate_property(self, 'displayed_hp', displayed_hp, hp, tween_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_tween_step(object, key, elapsed, value):
	var hp = round(value)
	HealthLeft.text = str(hp)
	ProgressBar.value = hp