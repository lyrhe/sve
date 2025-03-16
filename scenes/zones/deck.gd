class_name PlayerDeck extends Zone

var deck: Deck
var card_to_move: Card = null
@export var player_hand: Zone
@export var graveyard: Zone

func _ready() -> void:
	deck = Deck.new()
	deck.update_view.connect(_update_deck_ui)

# Gère les déplacements illégaux
func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.token == true:
		print("Deleting token")
		node.queue_free()
		return
	if node.previous_parent:
		var index = node.get_index()
		deck.top_card(node.metadata)
		print("deck contents:")
		for card in deck.cards:
			print(card.card_id)
		
func _update_deck_ui() -> void:
	var evo = evolve_deck.get_children().size()
	for child in cards_container.get_children():
		child.queue_free()
	for card in deck.cards:
		if not card.evolved:
			_spawn_card_ui(card, cards_container)
		elif card.evolved and evo == 0:
			_spawn_card_ui(card, evolve_deck)
		
func _on_card_drawn(card: Card) -> void:
	_spawn_card_ui(card, player_hand.cards_container)
		
func _spawn_card_ui(card: Card, parent: Node) -> void:
	var card_ui = load("res://scenes/card/CardUi.tscn").instantiate()
	card_ui.metadata = card
	card_ui.reparent_requested.connect(_on_card_reparent_requested)
	card_ui.bigger_frame = bigger_frame
	if not card.evolved:
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
		var max_visible = $"../Popups/SpinBox".value
		if max_visible <= 0:
			return
		var deck_ui_parent = cards_container.get_parent().get_parent()
		if deck_ui_parent.visible:
			deck_ui_parent.visible = false
			return
		deck_ui_parent.visible = true
		_update_visible_cards(max_visible)
	if event is InputEventMouseButton and Input.is_action_just_pressed("mouse_click"):
		deck.draw()
		
func _update_visible_cards(max_visible: int) -> void:
	for card_index in range(cards_container.get_child_count()):
		var child = cards_container.get_child(card_index)
		child.visible = (card_index < max_visible)

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
	var decklist = deserializer.load_cards_list(path, "res://assets/cards_database/total.json")
	deck.load_cards(decklist[0])
	for card in decklist[1]:
		_spawn_card_ui(card, evolve_deck)

func add_card(card_ui: CardUi) -> void:
	card_to_move = card_ui.metadata
	$"../Popups/SendTo".popup()

func mill() -> void:
	graveyard.add_card(cards_container.get_child(0))
	deck.cards.pop_front()
	deck.update_view.emit()
	pass

func _on_send_to_canceled() -> void:
	deck.bottom_card(card_to_move)

func _on_send_to_confirmed() -> void:
	deck.top_card(card_to_move)

func _on_mill_pressed() -> void:
	mill()
