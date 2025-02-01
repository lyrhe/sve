extends Sprite2D

@export var graveyard_container : GridContainer

func _on_graveyard_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('right_mouse_click'):
			print("mdr")
			if graveyard_container.visible == false:
				graveyard_container.visible = true
			elif graveyard_container.visible == true:
				graveyard_container.visible = false
