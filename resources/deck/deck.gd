class_name Deck extends Resource

signal update_view(cards: Array[Card])
signal draw_card(card: Card)

@export var cards: Array[Card] = []

func shuffle():
	cards.shuffle()
	update_view.emit(self.cards)
	
func get_top(i):
	return cards.slice(0, i)
	
func draw():
	if not cards.is_empty() :
		var drawn_card = cards.pop_front()
		draw_card.emit(drawn_card)
		update_view.emit(self.cards)
	print(cards)

func add_card(card: Card):
	self.cards.append(card)
	update_view.emit(self.cards)

func load_cards(new_cards_list: Array[Card]) -> void:
	self.cards = new_cards_list
	update_view.emit(self.cards)

func remove_card(index: int):
	self.cards.remove_at(index)
	update_view.emit(self.cards)
