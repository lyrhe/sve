extends Label

func transform_decklist():
	var cards := []
	
	for child in $"../CanvasLayer/ScrollContainer/Cards".get_children():
		cards.append({
			"card_name": child.metadata.card_name,
			"cost": child.metadata.cost
		})

	cards.sort_custom(func(a, b):
		if a.cost == b.cost:
			return a.card_name < b.card_name
		return a.cost < b.cost
	)

	var output := ""
	for card in cards:
		output += "(Cost: %s) %s\n" % [card.cost, card.card_name]
	return output

func _on_visibility_changed() -> void:
	if self.visible:
		print("now displaying text")
		$"../Label".text = "Deck - Text"
		print("Here's the decklist", self.text)
		self.text = transform_decklist()
		print("Here's the updated decklist", self.text)
	else:
		$"../Label".text = "Deck - Pictures"
