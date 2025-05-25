class_name Test2 extends Zone

@export var deckbuilding: Test
@export var deckbuilding_area: GridContainer
@export var scroll_container: ScrollContainer
@export var cards_in_deck: Label
@export var cards_in_evodeck: Label

var cards: Deck = Deck.new()

@onready var deck_area_base_size = self.size
@onready var deck_area_base_pos = self.position
@onready var scroll_container_base_size = scroll_container.size
@onready var scroll_container_base_pos = scroll_container.position
@onready var sidebar_base_pos = true

func _on_cards_child_entered_tree(node: Node) -> void:
	node.get_child(1).visible = false
	node.set_custom_minimum_size(Vector2(125, 176))
	node.get_child(0).set_scale(Vector2(1.09, 1.09))
	if node.previous_parent == node.get_parent():
		node.queue_free()
	# Sort by cost then name
	var children := cards_container.get_children()
	children.sort_custom(func(a, b):
		var card_a: Card = a.metadata
		var card_b: Card = b.metadata
		# Evolved cards go to the bottom
		if card_a.evolved and not card_b.evolved:
			return false
		elif not card_a.evolved and card_b.evolved:
			return true
		# Then sort by cost
		if card_a.cost == card_b.cost:
			return card_a.card_name < card_b.card_name
		return card_a.cost < card_b.cost
	)
	# Reorder nodes according to the sorted list
	for i in children.size():
		cards_container.move_child(children[i], i)
	node.move_to_deck.connect(zeub)
	$Decklist.text = $Decklist.transform_decklist()
	node.switch_rarity.connect(deckbuilding.switch_rarity_artwork)

func _on_cards_child_exiting_tree(node: Node) -> void:
	node.queue_free()
	
func _on_file_dialog_file_selected(path: String) -> void:
	load_card_database(path, "res://assets/cards_database/cards_formatted.json")

func load_card_database(path: String, db: String) -> void:
	var loaded_cards: Array[Card] = deserializer.load_decklist(path, db)
	cards.load_cards(loaded_cards)
	
	# Clear any existing cards in the UI
	for child in cards_container.get_children():
		child.queue_free()

	# Spawn CardUi nodes for each card
	for card in loaded_cards:
		spawn_cardui(card)

func spawn_cardui(card: Card) -> Control:
	var card_ui = load("res://scenes/card/CardUi.tscn").instantiate()
	card_ui.metadata = card
	card_ui.bigger_frame = bigger_frame
	card_ui.set_custom_minimum_size(Vector2(125, 176))
	card_ui.get_child(0).set_scale(Vector2(1.09, 1.09))
	card_ui.get_child(1).visible = false
	cards_container.add_child(card_ui)
	card_ui.connect("visibility_changed", Callable(self, "_on_card_visibility_changed"))
	card_ui.get_child(4).get_child(0).shape.set_size(Vector2(125, 176))
	card_ui.get_child(4).get_child(0).set_position(Vector2(71, 100))
	card_ui.move_to_deck.connect(zeub)
	deckbuilding.set_artwork(card_ui)
	return card_ui

func zeub(card):
	card.queue_free()

func _on_expand_decklist_pressed() -> void:
	if sidebar_base_pos:
		deckbuilding_area.visible = not deckbuilding_area.visible
		$Label.visible = not $Label.visible
		self.size = deckbuilding_area.size
		self.set_position(deckbuilding_area.position) 
		scroll_container.size = deckbuilding.scroll_container.size
		scroll_container.set_position(deckbuilding.scroll_container.position)
		cards_container.columns = 8
		$Shadow.visible = false
		sidebar_base_pos = false
	else:
		deckbuilding_area.visible = not deckbuilding_area.visible
		$Label.visible = not $Label.visible
		self.size = deck_area_base_size
		self.set_position(deck_area_base_pos)
		scroll_container.size = scroll_container_base_size
		scroll_container.set_position(scroll_container_base_pos)
		cards_container.columns = 3
		$Shadow.visible = true
		sidebar_base_pos = true

func _on_cards_child_order_changed():
	var deck_count := 0
	var evodeck_count := 0

	for card in cards_container.get_children():
		if not card.metadata.evolved:
			deck_count += 1
		elif card.metadata.evolved:
			evodeck_count += 1

	cards_in_deck.text = "Cards in deck: %d" % deck_count
	cards_in_evodeck.text = "Cards in evodeck: %d" % evodeck_count
