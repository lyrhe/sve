class_name Test extends Zone

var cards: Deck = Deck.new()
signal visible_card_count_changed(count: int)

func _ready():
	var evolve_deck = null
	load_card_database()
	display_cards()
	$DropZone/CollisionShape2D.disabled = true
	var shown_cards_label: Label = get_node("../Buttons/ShownCards")
	connect("visible_card_count_changed", Callable(self, "_on_visible_card_count_changed").bindv([shown_cards_label]))
	update_visible_card_count()

func load_card_database():
	cards.load_cards(deserializer.load_deckbuilder("res://assets/cards_list.txt", "res://assets/cards_database/total.json"))
	
func spawn_cardui(card: Card) -> Control:
	var card_ui = load("res://scenes/card/CardUi.tscn").instantiate()
	card_ui.metadata = card
	card_ui.bigger_frame = bigger_frame
	card_ui.set_custom_minimum_size(Vector2(125, 176))
	card_ui.get_child(0).set_scale(Vector2(1.09, 1.09))
	card_ui.get_child(1).visible = false
	cards_container.add_child(card_ui)
	card_ui.connect("visibility_changed", Callable(self, "_on_card_visibility_changed"))
	return card_ui
	
func display_cards():
	for card in cards.cards:
		spawn_cardui(card)

func _on_cards_child_exiting_tree(node: Node) -> void:
	var card_data = node.metadata as Card
	var index = cards_container.get_children().find(node) 
	if index == -1:
		index = cards_container.get_child_count()

	await get_tree().process_frame
	var new_card_ui = spawn_cardui(card_data)
	cards_container.move_child.call(new_card_ui, index)
	
func _on_card_visibility_changed():
	update_visible_card_count()

func update_visible_card_count():
	var count := 0
	for child in cards_container.get_children():
		if child.visible:
			count += 1
	emit_signal("visible_card_count_changed", count)

func _on_visible_card_count_changed(count: int, label: Label) -> void:
	label.text = "Visible Cards: %d" % count
