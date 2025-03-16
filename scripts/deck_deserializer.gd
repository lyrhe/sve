class_name DeckDeserializer extends Resource

func load_cards_list(deck_path, database_path) -> Array[Array]:
	var deck:= FileAccess.open(deck_path, FileAccess.READ)
	var database := FileAccess.open(database_path, FileAccess.READ)
	var content = database.get_as_text()
	var json = JSON.parse_string(content)
	
	var card_list: Array[Card] = []
	var evolve_card_list: Array[Card] = []
	
	while not deck.eof_reached():
		var card_id = deck.get_line().strip_edges()
		if card_id in json:
			var data = json[card_id]
			var new_card = Card.new()
			new_card.card_id = card_id
			new_card.cost = int(data.get("cost", "0"))
			new_card.attack = int(data.get("attack", "0"))
			new_card.defense = int(data.get("defense", "0"))
			new_card.evolved = data.get("evolved", false)
			if new_card.evolved:
				new_card.base = get_base(card_id)
				new_card.used = false
			new_card.token = data.get("token", false)
			new_card.type = data.get("type", "")
			if new_card.evolved:
				evolve_card_list.append(new_card)
			else:
				card_list.append(new_card)

	deck.close()
	database.close()
	
	
	return [card_list, evolve_card_list]

func load_card(card_id):
	var database := FileAccess.open("res://assets/cards_database/total.json", FileAccess.READ)
	var content = database.get_as_text()
	var json = JSON.parse_string(content)
	
	if card_id in json:
		var data = json[card_id]
		var new_card = Card.new()
		new_card.cost = int(data.get("cost", "0"))
		new_card.attack = int(data.get("attack", "0"))
		new_card.defense = int(data.get("defense", "0"))
		new_card.evolved = data.get("evolved", false)
		if new_card.evolved:
			new_card.base = get_base(card_id)
		new_card.token = data.get("token", false)
		new_card.card_id = data.get("code", "")
		new_card.type = data.get("type", "")
		return new_card
		
func get_base(card_id):
	var parts = card_id.split("-")
	if parts.size() == 2:
		var num = int(parts[1]) - 1
		var new_num = "%03d" % num
		return parts[0] + '-' + str(new_num)

func get_evolve(card_id):
	var parts = card_id.split("-")
	if parts.size() == 2:
		var num = int(parts[1]) + 1
		var new_num = "%03d" % num
		return parts[0] + '-' + str(new_num)

func load_deckbuilder(deck_path, database_path) -> Array[Card]:
	var deck:= FileAccess.open(deck_path, FileAccess.READ)
	var database := FileAccess.open(database_path, FileAccess.READ)
	var content = database.get_as_text()
	var json = JSON.parse_string(content)
	
	var card_list: Array[Card] = []
	
	while not deck.eof_reached():
		var card_id = deck.get_line().strip_edges()
		if card_id in json:
			var data = json[card_id]
			var new_card = Card.new()
			new_card.card_id = card_id
			new_card.cost = int(data.get("cost", "0"))
			new_card.attack = int(data.get("attack", "0"))
			new_card.defense = int(data.get("defense", "0"))
			new_card.evolved = data.get("evolved", false)
			if new_card.evolved:
				new_card.base = get_base(card_id)
				new_card.used = false
			new_card.token = data.get("token", false)
			new_card.type = data.get("type", "")
			card_list.append(new_card)

	deck.close()
	database.close()
	
	
	return card_list
