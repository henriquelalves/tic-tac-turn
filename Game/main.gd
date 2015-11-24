extends Spatial

# Reference to all cubes drawed on screen!
# Since GDScript doesn't support an 2D array, the easiest way to do this
# (which actually is easier than to actually use a 2D array) is to create
# a dictionary, in which the "Key" parameters is a Vector2, and the value
# is the reference for the Cube in that position. (Vector2 = Vector 2D)
var cubes = {}
var isRotating
var global
# Cubes that are changing their position
var temp_cubes = {}

# Current turn
var turn
var won = 0

																			
# "PUBLIC" FUNCTIONS!
func cube_clicked(cube):
	if(not isRotating and won == 0):
		cubes[cube].change_type(turn) #Set the cube
		_checkWinningCondition(turn) #Check winning condition
		if(won == 1):
			get_node("Stage").get_node("Win1").show()
		elif(won == 2):
			get_node("Stage").get_node("Win2").show()
		turn = (turn%2)+1 #Change the turn
	pass

# The function to rotate cubes!
func rotate_cubes(axis, wise):
		# Play JointPoint animation and change isRotating
	isRotating = true
	
	# Reparent cubes to JointPoint
	for cube_vector in temp_cubes:
		temp_cubes[cube_vector].get_parent().remove_child(temp_cubes[cube_vector])
		get_node("JointPoint").add_child(temp_cubes[cube_vector])
	
	# Correct cubes positions on dictionary arithmetically
	# Rotation matrix:
	var rot = Matrix3() # Identity Matrix
	rot.rotated(axis,90*wise) # Rotate it by the "axis", in a 90 degree (clockwise or counterclockwise)
	
	for cube_vector in temp_cubes:
		var newpos
		# Small translate correction
		newpos = cube_vector + Vector3(0.5, 0.5, 0.5)
		# Translate to origin
		newpos = newpos - Vector3(1.5, 1.5, 1.5)
		# Rotate
		newpos = rot * newpos
		# Retranslate from origin
		newpos = newpos + Vector3(1.5, 1.5, 1.5)
		# Translate recorrection
		newpos = newpos - Vector3(0.5, 0.5, 0.5)
		
		# Correction on dictionary
		temp_cubes[cube_vector].reference = newpos
		cubes[newpos] = temp_cubes[cube_vector]
	
	# Play correct animation
	if(axis == global.ROTATION_X_AXIS):
		if(wise == global.ROTATION_CLOCKWISE):
			get_node("AnimationPlayer").play("x_clockwise")
		elif(wise == global.ROTATION_COUNTERCLOCKWISE):
			get_node("AnimationPlayer").play("x_counterclockwise")
	elif(axis == global.ROTATION_Y_AXIS):
		if(wise == global.ROTATION_CLOCKWISE):
			get_node("AnimationPlayer").play("y_clockwise")
		elif(wise == global.ROTATION_COUNTERCLOCKWISE):
			get_node("AnimationPlayer").play("y_counterclockwise")
	elif(axis == global.ROTATION_Z_AXIS):
		if(wise == global.ROTATION_CLOCKWISE):
			get_node("AnimationPlayer").play("z_clockwise")
		elif(wise == global.ROTATION_COUNTERCLOCKWISE):
			get_node("AnimationPlayer").play("z_counterclockwise")
	
	pass

																			
# PRIVATE FUNCTIONS

func _ready():
	# Initialization here
	self.set_fixed_process(true)
	# This is for the cube creation via script; you need to reference the
	# resource that you are going to use
	var Cube = load("Game/cube.scn")
	
	# Easy global reference
	global = get_node("/root/global")
	
	# Setting up the cubes on the dictionary!
	for i in range(0, 3):
		for j in range(0, 3):
			for k in range(0, 3):
				if(i != 1 or j != 1 or k != 1):
					cubes[Vector3(i, j, k)] = Cube.instance() # Creating the cube here!
					add_child(cubes[Vector3(i, j, k)]) # Adding the cube as a child of the game scene!
					cubes[Vector3(i,j,k)].set_reference(Vector3(i,j,k)) # Set the reference for the cube!
					cubes[Vector3(i,j,k)].set_translation(Vector3((i-1)*2.01, (j-1)*2.01, (k-1)*2.01)) # Moving the cube!
	
	# Begins on turn 1 (player 1)
	turn = 1
	
	
	
	rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_COUNTERCLOCKWISE)
	
	pass

# Keyboard input
func _fixed_process(delta):
	if (Input.is_action_pressed("ui_down")):
		if(not isRotating):
			turn = (turn%2)+1 #Change the turn
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_CLOCKWISE)
	if (Input.is_action_pressed("ui_up")):
		if(not isRotating):
			turn = (turn%2)+1 #Change the turn
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_COUNTERCLOCKWISE)
	if (Input.is_action_pressed("ui_left")):
		if(not isRotating):
			turn = (turn%2)+1 #Change the turn
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_Y_AXIS,global.ROTATION_CLOCKWISE)
	if (Input.is_action_pressed("ui_right")):
		if(not isRotating):
			turn = (turn%2)+1 #Change the turn
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_Y_AXIS,global.ROTATION_COUNTERCLOCKWISE)
	pass

# AnimationPlayer signal when an animation has finished
func _on_AnimationPlayer_finished():
	# Reparent nodes of JointPoint to itself
	
	for cube_vector in temp_cubes:
		
		temp_cubes[cube_vector].set_transform(temp_cubes[cube_vector].get_global_transform())
		temp_cubes[cube_vector].get_parent().remove_child(temp_cubes[cube_vector])
		add_child(temp_cubes[cube_vector])
		
	isRotating = false
	
	temp_cubes.clear()
	get_node("JointPoint").set_rotation(Vector3(0,0,0))

func _checkWinningCondition(player):
	var tempCond = []
	
	# Front Size
	for vector in (global.VECTORS_FRONT_SIDE):
		tempCond.append(vector)
	for i in range(0, 3):
		if(cubes[tempCond[i]].type == player and cubes[tempCond[i+3]].type == player and cubes[tempCond[i+6]].type == player):
			won = player
	for i in range(0, 3):
		if(cubes[tempCond[i*3]].type == player and cubes[tempCond[i*3 + 1]].type == player and cubes[tempCond[i*3 + 2]].type == player):
			won = player
	if(cubes[tempCond[0]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[8]].type == player):
		won = player
	if(cubes[tempCond[2]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[6]].type == player):
		won = player
	
	# Back side
	tempCond.clear()
	for vector in (global.VECTORS_BACK_SIDE):
		tempCond.append(vector)
	for i in range(0, 3):
		if(cubes[tempCond[i]].type == player and cubes[tempCond[i+3]].type == player and cubes[tempCond[i+6]].type == player):
			won = player
	for i in range(0, 3):
		if(cubes[tempCond[i*3]].type == player and cubes[tempCond[i*3 + 1]].type == player and cubes[tempCond[i*3 + 2]].type == player):
			won = player
	if(cubes[tempCond[0]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[8]].type == player):
		won = player
	if(cubes[tempCond[2]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[6]].type == player):
		won = player
	# Left side
	tempCond.clear()
	for vector in (global.VECTORS_LEFT_SIDE):
		tempCond.append(vector)
	for i in range(0, 3):
		if(cubes[tempCond[i]].type == player and cubes[tempCond[i+3]].type == player and cubes[tempCond[i+6]].type == player):
			won = player
	for i in range(0, 3):
		if(cubes[tempCond[i*3]].type == player and cubes[tempCond[i*3 + 1]].type == player and cubes[tempCond[i*3 + 2]].type == player):
			won = player
	if(cubes[tempCond[0]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[8]].type == player):
		won = player
	if(cubes[tempCond[2]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[6]].type == player):
		won = player
	# Right side
	tempCond.clear()
	for vector in (global.VECTORS_RIGHT_SIDE):
		tempCond.append(vector)
	for i in range(0, 3):
		if(cubes[tempCond[i]].type == player and cubes[tempCond[i+3]].type == player and cubes[tempCond[i+6]].type == player):
			won = player
	for i in range(0, 3):
		if(cubes[tempCond[i*3]].type == player and cubes[tempCond[i*3 + 1]].type == player and cubes[tempCond[i*3 + 2]].type == player):
			won = player
	if(cubes[tempCond[0]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[8]].type == player):
		won = player
	if(cubes[tempCond[2]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[6]].type == player):
		won = player
	
	# Upper side
	tempCond.clear()
	for vector in (global.VECTORS_UP_SIDE):
		tempCond.append(vector)
	for i in range(0, 3):
		if(cubes[tempCond[i]].type == player and cubes[tempCond[i+3]].type == player and cubes[tempCond[i+6]].type == player):
			won = player
	for i in range(0, 3):
		if(cubes[tempCond[i*3]].type == player and cubes[tempCond[i*3 + 1]].type == player and cubes[tempCond[i*3 + 2]].type == player):
			won = player
	if(cubes[tempCond[0]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[8]].type == player):
		won = player
	if(cubes[tempCond[2]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[6]].type == player):
		won = player
	
	# Down side
	tempCond.clear()
	for vector in (global.VECTORS_DOWN_SIDE):
		tempCond.append(vector)
	for i in range(0, 3):
		if(cubes[tempCond[i]].type == player and cubes[tempCond[i+3]].type == player and cubes[tempCond[i+6]].type == player):
			won = player
	for i in range(0, 3):
		if(cubes[tempCond[i*3]].type == player and cubes[tempCond[i*3 + 1]].type == player and cubes[tempCond[i*3 + 2]].type == player):
			won = player
	if(cubes[tempCond[0]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[8]].type == player):
		won = player
	if(cubes[tempCond[2]].type == player and cubes[tempCond[4]].type == player and cubes[tempCond[6]].type == player):
		won = player
	
	
	pass