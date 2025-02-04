extends Label

var current_mana: int = 0
var max_mana: int = 0

func _ready():
	update_text()

func _input(event):
	if event is InputEventMouseButton and event.pressed and self.get_rect().has_point(get_global_mouse_position()):
		var local_pos = get_local_mouse_position()
		print(local_pos)
		var text_half = size.x / 1.33  # Divide text into two clickable halves
		print(text_half)

		if event.button_index == MOUSE_BUTTON_LEFT:  # Increase
			print(local_pos.x)
			if local_pos.x < text_half:
				current_mana += 1
			else:
				max_mana += 1
		elif event.button_index == MOUSE_BUTTON_RIGHT:  # Decrease
			if local_pos.x < text_half:
				current_mana = max(current_mana - 1, 0)  # Prevent negative values
			else:
				max_mana = max(max_mana - 1, 0)  # Prevent max mana from going below 1

		update_text()

func update_text():
	text = "Mana: " + str(current_mana) + " / " + str(max_mana)
