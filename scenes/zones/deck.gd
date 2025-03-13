class_name PlayerDeck extends Zone

var deck: Deck
@export var player_hand: Zone

func _ready() -> void:
	deck = Deck.new()
	deck.update_view.connect(_update_deck_ui)

# Gère les déplacements illégaux
func _on_cards_child_entered_tree(node: Node) -> void:
	#if node.metadata.evolved == true:
		#var evolved_clone = node.duplicate()
		#evolve_deck.add_child(evolved_clone)
		#node.metadata = deserializer.load_card(node.metadata.base)
	if node.metadata.token == true:
		print("Deleting token")
		node.queue_free()
		return
		
func _update_deck_ui() -> void:
	var evo = evolve_deck.get_children().size()
	for child in cards_container.get_children():
		child.queue_free()
	for card in deck.cards:
		if not card.evolved:
			_spawn_card_ui(card, cards_container)
		elif card.evolved and evo == 0:
			_spawn_card_ui(card, evolve_deck)
	print(deck.cards)
	for child in evolve_deck.get_children():
		print(child)
		
func _on_card_drawn(card: Card) -> void:
	_spawn_card_ui(card, player_hand.cards_container)
		
func _spawn_card_ui(card: Card, parent: Node) -> void:
	var card_ui = load("res://scenes/card/CardUi.tscn").instantiate()
	card_ui.metadata = card
	card_ui.reparent_requested.connect(_on_card_reparent_requested)
	card_ui.is_changing_zone.connect(on_card_changing_zone)
	parent.add_child(card_ui)

# Update Deck quand une carte est retirée manuellement
func on_card_changing_zone(card_ui: CardUi) -> void:
	var index = card_ui.get_index()
	if index >= 0 and index < deck.cards.size():
		deck.remove_card(index)

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

func _on_mulligan_pressed() -> void:
	for card in player_hand.cards_container.get_children():
		deck.bottom_card(card.metadata)
		card.queue_free()
	for i in range(4):
		deck.draw()

func _on_shuffle_pressed() -> void:
	deck.shuffle()

func _on_draw_pressed() -> void:
	deck.draw()

func _on_canvas_layer_visibility_changed() -> void:
	if cards_container.visible:
		for child in cards_container.get_children():
			child.visible = true

func _on_cards_child_order_changed() -> void:
	pass

func _on_file_dialog_file_selected(path: String) -> void:
	deck.load_cards(deserializer.load_cards_list(path, "res://assets/cards_database/total.json"))
