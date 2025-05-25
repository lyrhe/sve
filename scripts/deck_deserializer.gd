class_name DeckDeserializer extends Resource

const DATABASE = "res://scenes/card/states/cards_formatted.json"

# Tokens et chargement de deck in-game
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
			var card = card_creation(card_id)
			if not card.evolved and card != null:
				card_list.append(card)
			if card.evolved and card != null:
				evolve_card_list.append(card)
	deck.close()
	database.close()
	
	return [card_list, evolve_card_list]

# Charge la decklist du deckbuilder
func load_decklist(deck_path: String, database_path: String) -> Array[Card]:
	# Récupère le deck et la base de données
	var deck := FileAccess.open(deck_path, FileAccess.READ)
	var file := FileAccess.open(database_path, FileAccess.READ)
	var json_text := file.get_as_text()
	file.close()
	# Parse le contenu JSON
	var parsed: Array = JSON.parse_string(json_text)
	var card_lookup := {}
	# Dictionnaire par ID de carte
	for card_data in parsed:
		card_lookup[card_data.get("id", "")] = card_data
	var card_list: Array[Card] = []
	# Parcourt les ID de cartes du deck
	while not deck.eof_reached():
		var line := deck.get_line().strip_edges()
		if line == "":
			continue
		var parts = line.split("/")
		if parts.size() != 2:
			push_error("Invalid deck entry format: %s" % line)
			continue
		var card_id = parts[0]
		var rarity_index = int(parts[1])
		if card_id in card_lookup:
			var card_data: Dictionary = card_lookup[card_id]
			var card = card_creation(card_data)
			if card != null:
				card.rarity_index = rarity_index
				card_list.append(card)
	deck.close()
	print(card_list)
	return card_list

# Récupère une carte unique
func load_card(card_id):
	var database := FileAccess.open(DATABASE, FileAccess.READ)
	var content = database.get_as_text()
	var json = JSON.parse_string(content)
	
	if card_id in json:
		return card_creation(card_id)

# Renvoie la forme non-évoluée d'une carte évoluée
func get_base(card_id):
	var parts = card_id.split("-")
	var num = int(parts[1]) - 1
	var new_num = "%03d" % num
	return parts[0] + '-' + str(new_num)

# Renvoie la forme évoluée d'une carte non-évoluée
func get_evolve(card_id):
	var parts = card_id.split("-")
	if parts.size() == 2:
		var num = int(parts[1]) + 1
		var new_num = "%03d" % num
		return parts[0] + '-' + str(new_num)

# Charge le tiroir du deckbuilder
func load_deckbuilder(database_path: String) -> Array[Card]:
	# Récupère et parse le json, puis initiliase la liste de cartes
	var file := FileAccess.open(database_path, FileAccess.READ)
	var json_text := file.get_as_text()
	file.close()
	var parsed: Array = JSON.parse_string(json_text)
	var card_list: Array[Card] = []
	# Génère les métadonnées de chaque carte, skip si null
	for card_data in parsed:
		var card = card_creation(card_data)
		if card != null:
			card_list.append(card)
	return card_list

func card_creation(card_data):
	var new_card := Card.new()
	new_card.card_id = card_data.get("id", "")
	if new_card.card_id.length() < 6 or (
		new_card.card_id[5] == 'P' or new_card.card_id[5] == 'S' or 
		new_card.card_id[5] == 'U' or new_card.card_id[0] == "G" or 
		new_card.card_id[0] == "P" or new_card.card_id[2] == "F") or new_card.card_id[7] == 'S':
		return null
	new_card.cost = str(card_data.get("statistics", {}).get("cost", "0")).to_int()
	new_card.attack = str(card_data.get("statistics", {}).get("attack", "0")).to_int()
	new_card.defense = str(card_data.get("statistics", {}).get("defense", "0")).to_int()
	new_card.evolved = card_data.get("is_evolved", false)
	if new_card.evolved:
		new_card.base = get_base(new_card.card_id)
		new_card.used = false
	new_card.token = card_data.get("is_token", false)
	if new_card.token:
		return null
	new_card.type = card_data.get("types", [])[0] if card_data.get("types", []).size() > 0 else ""
	if new_card.type == "Leader" or new_card.type == "EvolutionPoint":
		return null
	new_card.card_class = card_data.get("class", "")
	new_card.rarity = card_data.get("rarity", "")
	new_card.universe = card_data.get("universe", "")
	new_card.card_traits = []
	for t in card_data.get("traits", []):
		new_card.card_traits.append(str(t))
	new_card.card_name = card_data.get("name", "")
	new_card.card_set = new_card.card_id.split("-")[0]
	new_card.card_effect = card_data.get("effect", "")
	new_card.release_date = card_data.get("release_date", "")
	new_card.related_cards = []
	for t in card_data.get("related_cards", []):
		new_card.related_cards.append(str(t))
	new_card.rarity_index = 0
	new_card.alternate_rarities = []
	for t in card_data.get("alternate_rarities", []):
		new_card.alternate_rarities.append(str(t))
	return new_card
