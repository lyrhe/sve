extends HBoxContainer

# Récupère le deck et preload la scène des cartes pour force_draw()
@export var player_deck : GridContainer
const card = preload("res://Scenes/card.tscn")

# Récupère les codes des cartes de la main, les ajoute au fond du deck, supprime la main, puis pioche quatre.
func _on_mulligan_pressed() -> void:
	var a = self.get_children()
	for n in a:
		player_deck.player_deck.append(n.name)
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	force_draw(4)

# Pioche un certain nombre de cartes
func force_draw(number):
	for n in range(0, number):
		player_deck.get_child(0).reparent_card(self)

# Supprime les cartes de la main
func _on_menu_button_2_pressed() -> void:
	for card in get_children():
		remove_child(card)
		card.queue_free()
