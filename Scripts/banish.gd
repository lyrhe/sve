extends Sprite2D

@export var banish : GridContainer
@export var board : Node2D

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('right_mouse_click'):
			board.only_one_container_visible(self.name)
			banish.visible = not banish.visible
