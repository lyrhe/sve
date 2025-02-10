extends CardState

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready
