class_name TokensDrawer extends Zone

var tokens_deck: Deck

func _ready() -> void:
	var tokens_cards_list = deserializer.load_cards_list("res://assets/tokens_list.txt", "res://assets/cards_database/tokens.json")
	
	self.tokens_deck = Deck.new()
	self.tokens_deck.load_cards(tokens_cards_list)
	self.tokens_deck.update_view.connect(_on_deck_changed)
	
	$DropZone/CollisionShape2D.disabled = true
	for card in tokens_deck.cards:
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)

func _on_tokens_pressed() -> void:
	if self.get_child(1).visible:
		self.get_child(1).visible = not self.get_child(1).visible
		return
	self.get_child(1).visible = not self.get_child(1).visible
	toggle_visibility.emit(self)
	
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
