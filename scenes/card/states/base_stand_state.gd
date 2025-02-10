extends CardState

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_click"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, State.CLICKED)
