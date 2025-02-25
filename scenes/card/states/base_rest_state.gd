extends CardState

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_click"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, State.CLICKED)
	if event.is_action_pressed("right_mouse_click"):
		if card_ui.get_parent().get_parent().name == "Field":
			card_ui.rotation_degrees = 0
			transition_requested.emit(self, State.BASE_STAND)
	if event.is_action_pressed("wheel_click") and card_ui.metadata.token == true:
		var token_replacement = card_ui.duplicate()
		card_ui.get_parent().add_child.call_deferred(token_replacement)
