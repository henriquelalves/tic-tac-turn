extends Node

# This script will be "auto-loaded" (Scene -> Project Settings -> AutoLoad),
# which means it's going to be loaded before the other scripts and scenes

# declaring constants
const MATERIAL_NEUTRAL = 0
const MATERIAL_PLAYER1 = 1
const MATERIAL_PLAYER2 = 2

# declaring variables
var materials = {}

func _ready():
	# Loading all materials on a dictionary
	materials["neutral"] = load("Assets/neutral_fixedmaterial.mtl")
	materials["player1"] = load("Assets/player1_fixedmaterial.mtl")
	materials["player2"] = load("Assets/player2_fixedmaterial.mtl")
	
	
	pass