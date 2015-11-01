extends Spatial

# Reference to all cubes drawed on screen!
# Since GDScript doesn't support an 2D array, the easiest way to do this
# (which actually is easier than to actually use a 2D array) is to create
# a dictionary, in which the "Key" parameters is a Vector2, and the value
# is the reference for the Cube in that position. (Vector2 = Vector 2D)
var cubes = {}

# Current turn
var turn

func cube_clicked(cube):
	cubes[cube].change_type(turn) #Set the cube
	turn = (turn%2)+1 #Change the turn
	pass

func _ready():
	# Initialization here
	
	# This is for the cube creation via script; you need to reference the
	# resource that you are going to use
	var Cube = load("Game/cube.scn")
	
	# Setting up the cubes on the dictionary!
	for i in range(0, 3):
		for j in range(0, 3):
			cubes[Vector2(i, j)] = Cube.instance() # Creating the cube here!
			add_child(cubes[Vector2(i, j)]) # Adding the cube as a child of the game scene!
			cubes[Vector2(i,j)].set_reference(Vector2(i,j)) # Set the reference for the cube!
			cubes[Vector2(i, j)].set_translation(Vector3((i-1)*3, (j-1)*3, 0)) # Moving the cube!
	
	# Begins on turn 1 (player 1)
	turn = 1
	
	pass


