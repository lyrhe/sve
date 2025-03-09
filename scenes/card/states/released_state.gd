extends CardState

var change_zone = false

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	if not card_ui.targets.is_empty():
		change_zone = true

func exit():
	if not change_zone:
		card_ui.reparent_requested.emit(card_ui)

func on_input(event: InputEvent):
	if change_zone and not card_ui.targets.is_empty():
		card_ui.targets[-1].add_card(card_ui)
		card_ui.is_changing_zone.emit(card_ui)
		card_ui.queue_free()
	transition_requested.emit(self, CardState.State.BASE_STAND)
