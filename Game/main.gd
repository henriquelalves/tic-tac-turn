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
var temp_cubes = []

# Current turn
var turn

																			
# "PUBLIC" FUNCTIONS!
func cube_clicked(cube):
	cubes[cube].change_type(turn) #Set the cube
	turn = (turn%2)+1 #Change the turn
	pass

# The function to rotate cubes!
func rotate_cubes(axis, wise):
	# Reparent cubes to JointPoint
	for cube in temp_cubes:
		cube.get_parent().remove_child(cube)
		get_node("JointPoint").add_child(cube)
	
	# Change dictionary cubes references
	
	
	# Play JointPoint animation and change isRotating
	isRotating = true
	
	get_node("AnimationPlayer").play("x_clockwise")
	
	pass

																			
# PRIVATE FUNCTIONS

func _ready():
	# Initialization here
	
	# This is for the cube creation via script; you need to reference the
	# resource that you are going to use
	var Cube = load("Game/cube.scn")
	
	# Easy global reference
	global = get_node("/root/global")
	
	# Setting up the cubes on the dictionary!
	for i in range(0, 3):
		for j in range(0, 3):
			for k in range(0, 3):
				cubes[Vector3(i, j, k)] = Cube.instance() # Creating the cube here!
				add_child(cubes[Vector3(i, j, k)]) # Adding the cube as a child of the game scene!
				cubes[Vector3(i,j,k)].set_reference(Vector3(i,j,k)) # Set the reference for the cube!
				cubes[Vector3(i,j,k)].set_translation(Vector3((i-1)*3, (j-1)*3, (k-1)*3)) # Moving the cube!
	
	# Begins on turn 1 (player 1)
	turn = 1
	
	for vector in (global.VECTORS_RIGHT_SIDE):
		temp_cubes.append(cubes[vector])
	
	rotate_cubes(0,0)
	
	pass

# AnimationPlayer signal when an animation has finished
func _on_AnimationPlayer_finished():
	# Reparent nodes of JointPoint to itself
	
	for cube in temp_cubes:
		
		cube.set_transform(cube.get_global_transform())
		cube.get_parent().remove_child(cube)
		add_child(cube)
		
	isRotating = false
	rotate_cubes(0,0)
