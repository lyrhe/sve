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
			card_ui.rotation_degrees = 90
			transition_requested.emit(self, State.BASE_REST)
		elif card_ui.get_parent().get_parent().get_parent().get_parent().name == "Evolve":
			print("flipping evo card")
			card_ui.metadata.used = not card_ui.metadata.used
			card_ui.get_parent().move_child(card_ui, 0)
			card_ui.update_shader()
			if not card_ui.get_parent().get_child(-1).metadata.used:
				card_ui.get_parent().get_parent().get_parent().get_parent().texture.texture = load("res://assets/card_back.jpg")
	if event.is_action_pressed("wheel_click") and card_ui.metadata.token == true:
		var token_replacement = card_ui.duplicate()
		card_ui.get_parent().add_child.call_deferred(token_replacement)
