extends Label

var id_to_name: Dictionary = {}  # Maps card_id -> card_name

func _ready() -> void:
	var file = FileAccess.open("res://assets/cards_database/cards_formatted.json", FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_ARRAY:
			for card in parsed:
				if card.has("id") and card.has("name"):
					id_to_name[card["id"]] = card["name"]
		else:
			push_error("cards_formatted.json is not an array!")
	else:
		push_error("Failed to load cards_formatted.json")

func transform_decklist() -> String:
	var evolved_cards: Dictionary = {}
	var normal_cards: Dictionary = {}
	var related_card_ids: Dictionary = {}

	for child in $"../CanvasLayer/ScrollContainer/Cards".get_children():
		var name: String = child.metadata.card_name
		var cost: int = child.metadata.cost
		var evolved: bool = child.metadata.evolved
		var related: Array = child.metadata.related_cards

		for card_id in related:
			if card_id[5] == "T":
				related_card_ids[card_id] = true 

		var target_dict := evolved_cards if evolved else normal_cards

		if target_dict.has(name):
			target_dict[name]["count"] += 1
		else:
			target_dict[name] = {
				"count": 1,
				"cost": cost
			}

	var output := "\nMain Deck: \n"

	var sorted_normal = build_sorted_list(normal_cards)
	for card in sorted_normal:
		output += "x%d - (%d) - %s\n" % [card["count"], card["cost"], card["card_name"]]

	if sorted_normal.size() > 0 and evolved_cards.size() > 0:
		output += "\nEvolve Deck: \n"

	var sorted_evolved = build_sorted_list(evolved_cards)
	for card in sorted_evolved:
		output += "x%d - (%d) - %s\n" % [card["count"], card["cost"], card["card_name"]]

	if related_card_ids.size() > 0:
		output += "\nNecessary tokens: \n"
		var sorted_ids := related_card_ids.keys()
		sorted_ids.sort()  # Sort card IDs for consistency
		for card_id in sorted_ids:
			if id_to_name.has(card_id):
				if not id_to_name[card_id] in output:
					output += "%s\n" % id_to_name[card_id]
			else:
				output += "[Missing name for ID: %s]\n" % card_id

	return output

func build_sorted_list(card_dict: Dictionary) -> Array:
	var card_array: Array[Dictionary] = []
	for name in card_dict.keys():
		var info: Dictionary = card_dict[name]
		card_array.append({
			"card_name": name,
			"cost": info["cost"],
			"count": info["count"]
		})

	var sort_func := func(a: Dictionary, b: Dictionary) -> bool:
		if a["cost"] == b["cost"]:
			return a["card_name"] < b["card_name"]
		return a["cost"] < b["cost"]

	card_array.sort_custom(sort_func)
	return card_array



	
func _on_visibility_changed() -> void:
	if self.visible:
		$"../Label".text = "Deck - Text"
		self.text = transform_decklist()
	else:
		$"../Label".text = "Deck - Pictures"
