extends Node

# This script will be "auto-loaded" (Scene -> Project Settings -> AutoLoad),
# which means it's going to be loaded before the other scripts and scenes

# declaring constants
const MATERIAL_NEUTRAL = 0
const MATERIAL_PLAYER1 = 1
const MATERIAL_PLAYER2 = 2

const ROTATION_X_AXIS = 0
const ROTATION_Y_AXIS = 1
const ROTATION_Z_ACIS = 2

const ROTATION_CLOCKWISE = 0
const ROTATION_COUNTERCLOCKWISE = 1

const VECTORS_LEFT_SIDE = [		Vector3(2,0,0),Vector3(2,0,1),Vector3(2,0,2),
								Vector3(2,1,0),Vector3(2,1,0),Vector3(2,1,2),
								Vector3(2,2,0),Vector3(2,2,1),Vector3(2,2,2)]
const VECTORS_RIGHT_SIDE = [	Vector3(0,0,0),Vector3(0,0,1),Vector3(0,0,2),
								Vector3(0,1,0),Vector3(0,1,0),Vector3(0,1,2),
								Vector3(0,2,0),Vector3(0,2,1),Vector3(0,2,2)]
const VECTORS_UP_SIDE = [		Vector3(0,2,0),Vector3(0,2,0),Vector3(0,2,2),
								Vector3(1,2,0),Vector3(1,2,1),Vector3(1,2,2),
								Vector3(2,2,0),Vector3(2,2,1),Vector3(2,2,2)]
const VECTORS_DOWN_SIDE = [		Vector3(0,0,0),Vector3(0,0,1),Vector3(0,0,2),
								Vector3(1,0,0),Vector3(1,0,1),Vector3(1,0,2),
								Vector3(2,0,0),Vector3(2,0,1),Vector3(2,0,2)]
const VECTORS_FRONT_SIDE = [	Vector3(0,0,0),Vector3(0,1,0),Vector3(0,2,0),
								Vector3(1,0,0),Vector3(1,1,0),Vector3(1,2,0),
								Vector3(2,0,0),Vector3(2,1,0),Vector3(2,2,0)]
const VECTORS_BACK_SIDE = [		Vector3(0,0,2),Vector3(0,1,2),Vector3(0,2,2),
								Vector3(1,0,2),Vector3(1,1,2),Vector3(1,2,2),
								Vector3(2,0,2),Vector3(2,1,2),Vector3(2,2,2)]

# declaring variables
var materials = {}

func _ready():
	# Loading all materials on a dictionary
	materials["neutral"] = load("Assets/neutral_fixedmaterial.mtl")
	materials["player1"] = load("Assets/player1_fixedmaterial.mtl")
	materials["player2"] = load("Assets/player2_fixedmaterial.mtl")
	
	
	pass