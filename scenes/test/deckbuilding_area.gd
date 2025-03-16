class_name Test extends Zone

var cards: Deck = Deck.new()

func _ready():
	var evolve_deck = null
	load_card_database()
	display_cards()

func load_card_database():
	cards.load_cards(deserializer.load_deckbuilder("res://assets/cards_list_demo.txt", "res://assets/cards_database/total.json"))
	
func spawn_cardui(card: Card):
	var card_ui = load("res://scenes/card/CardUi.tscn").instantiate()
	card_ui.metadata = card
	card_ui.bigger_frame = bigger_frame
	cards_container.add_child(card_ui)
	
func display_cards():
	for card in cards.cards:
		spawn_cardui(card)

func _on_cards_child_exiting_tree(node: Node) -> void:
	var index = node.get_index()
	var replacement = node.duplicate()
	cards_container.add_child.call_deferred(replacement)
	cards_container.move_child.call_deferred(replacement, index)
	replacement.bigger_frame = bigger_frame
