
extends RigidBody

# reference is used so the cube can know its place on the vector
var reference
var type

# function called by parent node, to set this cube reference
func set_reference(ref):
	reference = ref
	pass

# function to change the cube "type"
func change_type(newtype):
	if (newtype == 0):
		_change_material(get_node("/root/global").MATERIAL_NEUTRAL)
	elif (newtype == 1):
		_change_material(get_node("/root/global").MATERIAL_PLAYER1)
	else:
		_change_material(get_node("/root/global").MATERIAL_PLAYER2)
	
	self.type = newtype
	pass

func _change_material(newmaterial):
	# By getting the "global" node we created, it is possible to reference
	# the materials that were loaded on the "materials" dictionary!
	var material
	if (newmaterial == get_node("/root/global").MATERIAL_NEUTRAL):
		material = get_node("/root/global").materials["neutral"]
	elif (newmaterial == get_node("/root/global").MATERIAL_PLAYER1):
		material = get_node("/root/global").materials["player1"]
	else:
		material = get_node("/root/global").materials["player2"]
	
	# Override current mesh material
	get_node("Mesh").set_material_override(material)
	pass

func _input_event(camera,event,pos,normal,shape):
	if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
		# emit signal to notify parent!
		emit_signal("mouse_clicked", reference)


func _ready():
	# Initialization here
	
	# Signals are used so when the mouse click on one of the cubes, the function
	# on the parent scene is called
	add_user_signal("mouse_clicked")
	connect("mouse_clicked", get_parent(), "cube_clicked")
	
	pass


