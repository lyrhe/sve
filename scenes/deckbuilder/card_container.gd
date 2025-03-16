extends GridContainer

const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")
var deserializer = DeckDeserializer.new()
var cards: Deck = Deck.new()
@export var bigger_frame: CanvasLayer

func _ready():
	load_card_database()
	display_cards()
	
func load_card_database():
	cards.load_cards(deserializer.load_deckbuilder("res://assets/cards_list_demo.txt", "res://assets/cards_database/total.json"))
	
func spawn_cardui(card: Card):
	var card_ui = load("res://scenes/card/CardUi.tscn").instantiate()
	card_ui.metadata = card
	card_ui.bigger_frame = bigger_frame
	add_child(card_ui)

func display_cards():
	for card in cards.cards:
		spawn_cardui(card)

func add_card(card_ui):
	card_ui.queue_free()
