extends CardState

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	card_ui.scale = Vector2(1.2, 1.2)

func on_input(event: InputEvent):
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
