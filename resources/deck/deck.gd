class_name Deck extends Resource

@export var cards: Array[Card] = []

func shuffle():
	cards.shuffle()
	
func get_top(i):
	return cards.slice(0, i)
	
func draw():
	cards.pop_front()
	
	
