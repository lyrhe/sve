class_name PlayerDeck extends Zone

var deck = Deck.new()

func _ready() -> void:
	for card in deserializer.load_deck("res://Test/decklist_BP01.txt", "res://assets/cards_database/total.json"):
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)
		new_child.get_child(0).texture = load(new_child.CARDS_GRAPHICS_PATH + "/" + new_child.metadata.card_id + ".png")
