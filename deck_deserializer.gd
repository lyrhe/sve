class_name DeckDeserializer extends Resource

func load_deck(deck_path, database_path):
	var deck:= FileAccess.open(deck_path, FileAccess.READ)
	var database := FileAccess.open(database_path, FileAccess.READ)
	var content = database.get_as_text()
	var json = JSON.parse_string(content)
	
	var card_list: Array = []
	
	while not deck.eof_reached():
		var card_id = deck.get_line().strip_edges()
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
			card_list.append(new_card)

	deck.close()
	database.close()
	
	return card_list

func load_card(card_id):
	var database := FileAccess.open("res://assets/test_bp01.json", FileAccess.READ)
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
		return new_card
		
func get_base(card_id):
	var parts = card_id.split("-")
	if parts.size() == 2:
		var num = int(parts[1]) - 1
		var new_num = "%03d" % num
		return parts[0] + '-' + str(new_num)
