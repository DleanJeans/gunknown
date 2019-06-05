extends Sprite3D

export var max_hp = 100 setget _set_max_hp
export var hp = 100 setget _set_hp

var progress_bar:TextureProgress setget, _get_progress_bar
func _get_progress_bar(): return $Viewport/Progress

func _ready():
	texture = $Viewport.get_texture()

func _set_max_hp(value):
	max_hp = value
	self.progress_bar.max_value = value

func _set_hp(value):
	hp = value
	self.progress_bar.value = value