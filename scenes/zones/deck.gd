class_name PlayerDeck extends Zone

var deck: Deck

func _ready() -> void:
	self.deck = Deck.new()
	self.deck.load_cards(deserializer.load_cards_list("res://decklists/decklist_BP01.txt", "res://assets/cards_database/total.json"))
	self.deck.update_view.connect(_on_deck_changed)
	spawn_cards(self.deck.cards)
	
func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved == true:
		var evolved_clone = node.duplicate()
		$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
		node.metadata = deserializer.load_card(node.metadata.base)
	if node.metadata.token == true:
		print("Deleting token")
		node.queue_free()
		return
	else:
		$"../Popups/SendTo".visible = not $"../Popups/SendTo".visible

# Charge le deck sélectionné
func _on_file_dialog_file_selected(path: String) -> void:
	deck.load_cards(deserializer.load_cards_list(path, "res://assets/cards_database/total.json"))
	spawn_cards(deck.cards)

# Supprime les cartes du deck pour ajouter les nouvelles
func _on_deck_changed(cards: Array[Card]):
	# Delete all the nodes in the cards container
	for child in cards_container.get_children():
		child.queue_free()
	
	# Add all the cards nodes based on the list
	spawn_cards(cards)

# Ajoute une CardUI à chaque Card du deck
func spawn_cards(cards: Array[Card]):
	for card in cards:
		var new_child: CardUi = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		cards_container.add_child(new_child)
		$"../Popups/SendTo".visible = not $"../Popups/SendTo".visible

func _on_send_to_confirmed() -> void:
	self.cards_container.move_child(cards_container.get_child(-1), 0)
