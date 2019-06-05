extends CPUParticles

var material_color = Color.white setget _set_material_color
func _set_material_color(value):
	material_color = value
	mesh.material.albedo_color = value