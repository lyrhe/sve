extends Sprite2D

@export var graveyard_container : GridContainer

func _on_graveyard_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('right_mouse_click'):
			graveyard_container.visible = not graveyard_container.visible
