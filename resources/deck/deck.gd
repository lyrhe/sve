class_name Deck extends Resource

signal update_view()
signal draw_card(card: Card)

@export var cards: Array[Card] = []

func shuffle():
	cards.shuffle()
	update_view.emit()
	
func get_top(i):
	return cards.slice(0, i)
	
func draw():
	if not cards.is_empty() :
		var drawn_card = cards.pop_front()
		draw_card.emit(drawn_card)
		update_view.emit()

func add_card(card: Card, pos):
	self.cards.insert(pos, card)
	update_view.emit()
	
func bottom_card(card):
	self.cards.append(card)
	update_view.emit

func load_cards(new_cards_list: Array[Card]) -> void:
	self.cards = new_cards_list
	for card in cards:
		print(card.card_id)
	update_view.emit()

func remove_card(index: int):
	self.cards.remove_at(index)
	update_view.emit()
