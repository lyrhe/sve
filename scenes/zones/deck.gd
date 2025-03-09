class_name PlayerDeck extends Zone

var deck: Deck

func _ready() -> void:
	self.deck = Deck.new()
	self.deck.update_view.connect(_on_deck_changed)
	
func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved == true and node.previous_parent.get_parent().get_parent().get_parent().name == "Evolve":
		var evolved_clone = node.duplicate()
		$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
		node.queue_free()
		return
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

func on_card_changing_zone(card_ui: CardUi):
	deck.remove_card(card_ui.get_index())
	pass

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
	pass

# Ajoute une CardUI à chaque Card du deck
func spawn_cards(cards: Array[Card]):
	var evo = $"../Evolve".cards_container.get_children().size()
	for card in cards:
		if card.evolved == false:
			var new_child = load("res://scenes/card/CardUi.tscn").instantiate();
			new_child.reparent_requested.connect(_on_card_reparent_requested)
			new_child.metadata = card
			new_child.is_changing_zone.connect(on_card_changing_zone)
			cards_container.add_child(new_child)
		elif card.evolved == true and evo == 0:
			var new_child: CardUi = CARD_UI_SCENE.instantiate();
			new_child.metadata = card
			$"../Evolve".cards_container.add_child(new_child)
		$"../Popups/SendTo".visible = false

func _on_send_to_confirmed() -> void:
	self.cards_container.move_child(cards_container.get_child(-1), 0)

func _on_drop_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("right_mouse_click"):
		if cards_container.get_parent().get_parent().visible == true:
			toggle_cards_list(false)
		else:
			toggle_visibility.emit(self)
	if event is InputEventMouseButton and Input.is_action_just_pressed("wheel_click") and $"../Popups/SpinBox".value > 0 :
		if cards_container.get_parent().get_parent().visible == true:
			cards_container.get_parent().get_parent().visible = not cards_container.get_parent().get_parent().visible
			return
		for card_index in range(0, cards_container.get_child_count()):
			var child = cards_container.get_child(card_index)
			child.visible = (card_index < $"../Popups/SpinBox".value)
			self.toggle_cards_list(true)
	if event is InputEventMouseButton and Input.is_action_just_pressed("mouse_click"):
		deck.draw()

func _on_shuffle_pressed() -> void:
	deck.shuffle()

func _on_draw_pressed() -> void:
	deck.draw()
	
# Reset la visibilité après un check top X
func _on_canvas_layer_visibility_changed() -> void:
	if cards_container.visible:
		for child in cards_container.get_children():
			child.visible = true
