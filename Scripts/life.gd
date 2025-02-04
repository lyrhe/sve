extends Label

var life_count: int = 20

func _ready():
	text = str("Life : ", life_count) 

func _input(event):
	if event is InputEventMouseButton and event.pressed and self.get_rect().has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_LEFT:
			life_count += 1
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			life_count -= 1
		
		text = str("Life : ", life_count)
