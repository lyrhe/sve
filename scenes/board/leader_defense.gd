extends Label

var number: int = 20

func _ready():
	number = int(text)

func _input(event):
	if get_global_rect().has_point(get_viewport().get_mouse_position()):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				number += 1
				self.text = ("Defense : " + str(number))
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				number -= 1
				self.text = ("Defense : " + str(number))
