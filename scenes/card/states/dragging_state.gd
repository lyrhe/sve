extends CardState

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	card_ui._zone_detector.monitoring = true
	card_ui.previous_parent = card_ui.get_parent()
	card_ui.z_index = 2

func exit():
	card_ui.scale = Vector2(1, 1)
	card_ui.z_index = 0

func on_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_click"):
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		return
	
	if Input.is_action_just_released("mouse_click"):
		transition_requested.emit(self, CardState.State.RELEASED)
