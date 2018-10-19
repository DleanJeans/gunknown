extends Control

onready var AmmoLeft = $Labels/AmmoLeft
onready var MaxAmmo = $Labels/MaxAmmo

var player:Gunner
var gun:Gun

func set_player(player:Gunner):
	self.player = player
	
	player.connect('got_new_gun', self, '_show_self')
	player.connect('shot', self, '_update_count')
	player.connect('ran_out_of_ammo', self, 'hide')

func _show_self():
	gun = player.get_node('Gun')
	show()
	AmmoLeft.text = '?'
	MaxAmmo.text = '/ ?'

func _update_count():
	AmmoLeft.text = str(gun.ammo_left)
	MaxAmmo.text = '/ %s' % str(gun.initial_ammo)