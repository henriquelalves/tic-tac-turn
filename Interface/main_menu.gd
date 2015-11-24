extends Control

# member variables here, example:# var a=2
# var b="textvar"

const START = 0
const QUIT = 1

func _ready():
	# Initialization here
	pass


func _on_Buttons_button_selected( button ):
	if button == START:
		print("Start")
		get_node("/root/global").goto_scene("res://Game/main.scn")
		print("Start")
	elif button == QUIT:
		get_tree().quit()
	pass # replace with function body
