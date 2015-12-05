
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _input_event(viewport, event, shape_idx):
	
	if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
		# call parent function!... this is a very ugly fix
		get_parent().get_parent().arrow_clicked(self)


func _ready():
	# Initialization here
	pass


