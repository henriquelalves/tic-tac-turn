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
	if(not isRotating and won == 0 and cubes[cube].type == 0):
		cubes[cube].change_type(turn) #Set the cube
		var winningCubes = _checkWinningCondition(turn) #Check winning condition
		if(won != 0):
			if(won == 1):
				get_node("Stage").get_node("Win1").show()
			elif(won == 2):
				get_node("Stage").get_node("Win2").show()
			
			get_node("Stage/Description").hide()
			get_node("Stage/Turn1").hide()
			get_node("Stage/Turn2").hide()
			
			for cube in winningCubes:
				print(winningCubes.size())
				cube.set_flashing(true)
		else:
			change_turn()
	pass

# The function to rotate cubes!
func rotate_cubes(axis, wise):
	# Hide arrows
	get_node("Stage/Arrow_down").hide() 
	get_node("Stage/Arrow_right").hide()
	get_node("Stage/Arrow_left").hide()
	get_node("Stage/Arrow_up").hide()
	
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

# When an arrows is clicked
func arrow_clicked(arrow):
	for vector in (global.VECTORS_ALL):
		temp_cubes[vector] = cubes[vector]
	if(arrow == get_node("Stage/Arrow_down")):
		rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_CLOCKWISE)
	elif(arrow == get_node("Stage/Arrow_left")):
		rotate_cubes(global.ROTATION_Y_AXIS,global.ROTATION_CLOCKWISE)
	elif(arrow == get_node("Stage/Arrow_right")):
		rotate_cubes(global.ROTATION_Y_AXIS,global.ROTATION_COUNTERCLOCKWISE)
	elif(arrow == get_node("Stage/Arrow_up")):
		rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_COUNTERCLOCKWISE)

func change_turn():
	turn = (turn%2)+1 # alternates between player 1 and player 2
	
	# Change text label
	if(turn == 1):
		get_node("Stage/Turn2").hide()
		get_node("Stage/Turn1").show()
	elif(turn == 2):
		get_node("Stage/Turn1").hide()
		get_node("Stage/Turn2").show()
	

																			
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
	
	pass

# Keyboard input
func _fixed_process(delta):
	if (Input.is_action_pressed("ui_down")):
		if(not isRotating):
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_CLOCKWISE)
	if (Input.is_action_pressed("ui_up")):
		if(not isRotating):
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_X_AXIS,global.ROTATION_COUNTERCLOCKWISE)
	if (Input.is_action_pressed("ui_left")):
		if(not isRotating):
			for vector in (global.VECTORS_ALL):
				temp_cubes[vector] = cubes[vector]
			rotate_cubes(global.ROTATION_Y_AXIS,global.ROTATION_CLOCKWISE)
	if (Input.is_action_pressed("ui_right")):
		if(not isRotating):
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
	
	# Show arrows again
	get_node("Stage/Arrow_down").show()
	get_node("Stage/Arrow_right").show()
	get_node("Stage/Arrow_left").show()
	get_node("Stage/Arrow_up").show()
	
	# When animation ends, change turn
	if(won == 0):
		change_turn()
	
	# Reset selected cubes and JointPoint
	temp_cubes.clear()
	get_node("JointPoint").set_rotation(Vector3(0,0,0))

func _checkWinningCondition(player):
	var side = []
	var winningCubes = []
	
	# Front Size
	for vector in (global.VECTORS_FRONT_SIDE):
		side.append(vector)
	winningCubes = _check_side(side,player)
	
	if not winningCubes.empty():
		return winningCubes
	
	# Back side
	side.clear()
	for vector in (global.VECTORS_BACK_SIDE):
		side.append(vector)
	winningCubes = _check_side(side,player)
	
	if not winningCubes.empty():
		return winningCubes
	
	# Right side
	side.clear()
	for vector in (global.VECTORS_RIGHT_SIDE):
		side.append(vector)
	winningCubes = _check_side(side,player)
	
	if not winningCubes.empty():
		return winningCubes
	
	# Left side
	side.clear()
	for vector in (global.VECTORS_LEFT_SIDE):
		side.append(vector)
	winningCubes = _check_side(side,player)
	
	if not winningCubes.empty():
		return winningCubes
	
	# Upper side
	side.clear()
	for vector in (global.VECTORS_UP_SIDE):
		side.append(vector)
	winningCubes = _check_side(side,player)
	
	if not winningCubes.empty():
		return winningCubes
	
	# Down side
	side.clear()
	for vector in (global.VECTORS_DOWN_SIDE):
		side.append(vector)
	winningCubes = _check_side(side,player)
	
	if not winningCubes.empty():
		return winningCubes
	
	return winningCubes

func _check_side(side,player):
	var winningCubes = []
	
	for i in range(0, 3): # Vertical
		if(cubes[side[i]].type == player and cubes[side[i+3]].type == player and cubes[side[i+6]].type == player):
			won = player
			winningCubes.append(cubes[side[i]])
			winningCubes.append(cubes[side[i+3]])
			winningCubes.append(cubes[side[i+6]])
			return winningCubes
	for i in range(0, 3): # Horizontal
		if(cubes[side[i*3]].type == player and cubes[side[i*3 + 1]].type == player and cubes[side[i*3 + 2]].type == player):
			won = player
			winningCubes.append(cubes[side[i*3]])
			winningCubes.append(cubes[side[i*3+1]])
			winningCubes.append(cubes[side[i*3+2]])
			return winningCubes
	if(cubes[side[0]].type == player and cubes[side[4]].type == player and cubes[side[8]].type == player):
		won = player # Diagonal 1
		winningCubes.append(cubes[side[0]])
		winningCubes.append(cubes[side[4]])
		winningCubes.append(cubes[side[8]])
		return winningCubes
	if(cubes[side[2]].type == player and cubes[side[4]].type == player and cubes[side[6]].type == player):
		won = player # Diagonal 2
		winningCubes.append(cubes[side[2]])
		winningCubes.append(cubes[side[4]])
		winningCubes.append(cubes[side[6]])
		return winningCubes
	return winningCubes