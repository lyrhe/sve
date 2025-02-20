class_name PlayerDeck extends Zone

@onready var deck = deserializer.load_deck("res://decklists/decklist_BP01.txt", "res://assets/cards_database/total.json")

func _ready() -> void:
	for card in deck.cards:
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)

func _on_cards_child_entered_tree(node: Node) -> void:
	#if node.metadata.evolved == true:
		#var evolved_clone = node.duplicate()
		#$"../Evolve/CanvasLayer/Cards".add_child(evolved_clone)
		#node.metadata = deserializer.load_card(node.metadata.base)
		#node.card_id = node.metadata.card_id
	if node.metadata.token == true:
		print("Deleting token")
		node.queue_free()

func _on_file_dialog_file_selected(path: String) -> void:
	deck = deserializer.load_deck(path, "res://assets/cards_database/total.json")
	for card in deck.cards:
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)
