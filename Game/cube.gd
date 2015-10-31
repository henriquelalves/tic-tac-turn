
extends MeshInstance

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	var material = load("Color_icon_red.png")
	self.get_mesh().surface_set_material(0, material)
	
	pass


