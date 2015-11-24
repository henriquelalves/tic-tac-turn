
extends RigidBody

# reference is used so the cube can know its place on the vector
var reference
var type = 0
var flashing = false
var colorsin = 0

# function called by parent node, to set this cube reference
func set_reference(ref):
	reference = ref
	pass

func set_flashing(b):
	flashing = b

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
		# call parent function!
		get_parent().cube_clicked(reference)


func _ready():
	# Initialization here
	set_fixed_process(true)
	pass

# Just a pretty flashing effect when a player wins
func _fixed_process(delta):
	if(flashing):
		var material = get_node("Mesh").get_material_override()
		var c = 15 + sin(colorsin)*10
		material.set_parameter(3, Color(c,c,c))
		colorsin += 0.1
		get_node("Mesh").get_mesh().surface_set_material(0, material)
	pass
