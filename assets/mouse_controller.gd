extends Node

var clicked = false;

func _process(_delta):
	if(Input.is_action_just_pressed("click")):
		clicked = !clicked
		print("clicked: ")
		print(clicked)
