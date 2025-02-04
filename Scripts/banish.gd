extends Sprite2D

@export var banish : GridContainer

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('right_mouse_click'):
			banish.visible = not banish.visible
