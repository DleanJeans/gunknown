extends Control

onready var AmmoLeft = $Labels/AmmoLeft
onready var MaxAmmo = $Labels/MaxAmmo

var player:Gunner
var gun:Gun
var gun_ref:WeakRef

func set_player(player:Gunner):
	self.player = player
	
	player.connect('got_new_gun', self, '_show_self')
	player.connect('shot', self, '_update_count')
	player.connect('ran_out_of_ammo', $AnimationPlayer, 'play_backwards', ['Show'])

func _show_self():
	gun = player.get_node('Gun')
	gun_ref = weakref(gun)
	AmmoLeft.text = '?'
	MaxAmmo.text = '/ ?'
	$AnimationPlayer.play('Show')

func _update_count():
	if gun_ref.get_ref():
		AmmoLeft.text = str(gun.ammo_left)
		MaxAmmo.text = '/ %s' % str(gun.initial_ammo)