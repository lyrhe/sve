extends Zone

func add_card(card: CardUi):
	var new_child = CARD_UI_SCENE.instantiate();
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.card_id = card.card_id
	new_child.previous_parent = card.previous_parent
	new_child.metadata = deserializer.load_card(card.card_id)
	if new_child.metadata == null:
		push_error("Error: Failed to load metadata for card_id: " + card.card_id)
		return
	print(new_child.metadata.card_id)
	cards_container.add_child(new_child)
