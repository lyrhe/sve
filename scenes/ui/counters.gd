extends Label

var number: int = 0

func _ready():
	number = int(text)

func _input(event):
	if get_global_rect().has_point(get_viewport().get_mouse_position()):
		if event.is_action_pressed("number_plus"):
			number += 1
			self.text = str(number)
		elif event.is_action_pressed("number_minus"):
			number -= 1
			self.text = str(number)
