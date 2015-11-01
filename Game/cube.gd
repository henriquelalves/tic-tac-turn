
extends RigidBody

# reference is used so the cube can know its place on the vector
var reference
var type

# Constants to make material changing easier
const MATERIAL_NEUTRAL = 0
const MATERIAL_PLAYER1 = 1
const MATERIAL_PLAYER2 = 2

# function called by parent node, to set this cube reference
func set_reference(ref):
	reference = ref
	pass

# function to change the cube "type"
func change_type(newtype):
	if (newtype == 0):
		_change_material(MATERIAL_NEUTRAL)
	elif (newtype == 1):
		_change_material(MATERIAL_PLAYER1)
	else:
		_change_material(MATERIAL_PLAYER2)
	
	self.type = newtype
	pass

func _change_material(newmaterial):
	# Actuallly, this next code is a very bad practice (so its only temporary!);
	# the correct thing to do would be to load all the materials on a global
	# dictionary, and just reference it with the variable "material", so to
	# not load the materials every time this function is called
	var material
	if (newmaterial == MATERIAL_NEUTRAL):
		material = load("res://Assets/neutral_fixedmaterial.mtl")
	elif (newmaterial == MATERIAL_PLAYER1):
		material = load("res://Assets/player1_fixedmaterial.mtl")
	else:
		material = load("res://Assets/player2_fixedmaterial.mtl")
	
	# Override current mesh material
	get_node("Mesh").set_material_override(material)
	pass

func _input_event(camera,event,pos,normal,shape):
	if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
		# emit signal to notify parent!
		emit_signal("mouse_clicked", reference)


func _ready():
	# Initialization here
	
	# Cube initial type is always neutral
	change_type(0)
	
	# Signals are used so when the mouse click on one of the cubes, the function
	# on the parent scene is called
	add_user_signal("mouse_clicked")
	connect("mouse_clicked", get_parent(), "cube_clicked")
	
	pass


