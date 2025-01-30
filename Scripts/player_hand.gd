extends HBoxContainer

@export var player_deck : Sprite2D
const card = preload("res://Scenes/card.tscn")

func hand():
	print(player_deck.player_deck)
	print(self.get_children())
	var a = self.get_children()
	for n in a:
		print(n.name)
		player_deck.player_deck.append(n.name)
	print(player_deck.player_deck)
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
		
	force_draw(4)

func _on_mulligan_pressed() -> void:
	hand() # Replace with function body.

func force_draw(number):
	for n in range(0, number):
		var card_instance = card.instantiate()
		var card_code = player_deck.player_deck.pop_front()
		var texture_path = "res://Assets/card_images/%s.png" % card_code
		var texture = load(texture_path)
		if card_instance is TextureRect:
			card_instance.texture = texture
		self.add_child(card_instance)
		card_instance.name = card_code
		print(card_instance.name)
