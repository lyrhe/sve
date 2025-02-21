class_name PlayerDeck extends Zone

var deck: Deck
var timer: Timer = Timer.new()

func _ready() -> void:
	timer.autostart = true
	timer.wait_time = 5.0
	timer.start()
	
	self.deck = Deck.new()
	self.deck.load_cards(deserializer.load_deck("res://decklists/decklist_BP01.txt", "res://assets/cards_database/total.json"))
	self.deck.update_view.connect(_on_deck_changed)
	spawn_cards(self.deck.cards)

func process():
	if self.timer.time_left <= 0.0:
		self.deck.shuffle()
		self.deck.draw()

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
	deck.load_cards(deserializer.load_deck(path, "res://assets/cards_database/total.json"))
	spawn_cards(deck.cards)
		
func _on_deck_changed(cards: Array[Card]):
	# Delete all the nodes in the cards container
	for child in cards_container.get_children():
		child.queue_free()
	
	# Add all the cards nodes based on the list
	spawn_cards(cards)

func spawn_cards(cards: Array[Card]):
	for card in cards:
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)
