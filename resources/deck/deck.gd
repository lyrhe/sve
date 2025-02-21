class_name Deck extends Resource

signal update_view(cards: Array[Card])

@export var cards: Array[Card] = []

func shuffle():
	cards.shuffle()
	update_view.emit(self.cards)
	
func get_top(i):
	return cards.slice(0, i)
	
func draw():
	cards.pop_front()
	update_view.emit(self.cards)
	
func load_cards(new_cards_list: Array[Card]) -> void:
	self.cards = new_cards_list
	update_view.emit(self.cards)
