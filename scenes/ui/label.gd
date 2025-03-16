extends Label

var number: int = 0

func _ready():
	number = int(text)

func _input(event):
	if get_global_rect().has_point(get_viewport().get_mouse_position()):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				number += 1
				self.text = str(number)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				number -= 1
				self.text = str(number)
