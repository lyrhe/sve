extends HBoxContainer

# Récupère le deck et preload la scène des cartes pour force_draw()
@export var player_deck : Sprite2D
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
		var card_instance = card.instantiate()
		var card_code = player_deck.player_deck.pop_front()
		var texture_path = "res://Assets/card_images/%s.png" % card_code
		var texture = load(texture_path)
		if card_instance is TextureRect:
			card_instance.texture = texture
		card_instance.card_code = card_code
		self.add_child(card_instance)
		card_instance.name = card_code
		print(card_instance.name)
