extends Zone

func add_card(card: CardUi):
	var new_child = CARD_UI_SCENE.instantiate();
	cards_container.add_child(new_child)
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.card_id = card.card_id
