class_name TokensDrawer extends Zone

# Déclare une ressource Deck
var tokens_deck: Deck

# Deserialize la liste de tokens, instancie un Deck, ajoute les Cards,
# connecte le signal update_view du deck à _on_deck_changed,
# désactive la zone de colision, ajoute une CardUI à chaque Card
func _ready() -> void:
	var tokens_cards_list = deserializer.load_cards_list("res://assets/tokens_list.txt", "res://assets/cards_database/tokens.json")
	
	self.tokens_deck = Deck.new()
	self.tokens_deck.load_cards(tokens_cards_list)
	self.tokens_deck.update_view.connect(_on_deck_changed)
	
	$DropZone/CollisionShape2D.disabled = true
	spawn_cards(tokens_cards_list)

# Si le tiroir est visible : le rend invisible et stop la méthode.
# Sinon, le rend visible et emet de quoi rendre les autres invisibles.
func _on_tokens_pressed() -> void:
	if self.get_child(1).visible:
		self.get_child(1).visible = not self.get_child(1).visible
		return
	self.get_child(1).visible = not self.get_child(1).visible
	toggle_visibility.emit(self)

# Remplace un token qui sort du tiroir
func _on_cards_child_exiting_tree(node: Node) -> void:
	var index = node.get_index()
	var token_replacement = node.duplicate()
	cards_container.add_child.call_deferred(token_replacement)
	cards_container.move_child.call_deferred(token_replacement, index)

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
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		cards_container.add_child.call_deferred(new_child)
