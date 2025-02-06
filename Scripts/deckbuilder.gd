extends Control

const card = preload("res://Scenes/card.tscn")
var cards = {}

func _ready():
	load_card_database()
	display_cards()

func load_card_database():
	var dir = DirAccess.open("res://Assets/sets_db/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				var file = FileAccess.open("res://Assets/sets_db/" + file_name, FileAccess.READ)
				if file:
					var json_data = JSON.parse_string(file.get_as_text())
					if json_data is Array:  # Ensure it's an array
						for card in json_data:
							if "code" in card:  # Check that the key exists
								cards[card["code"]] = card
			file_name = dir.get_next()

func display_cards():
	var card_container = $ScrollContainer/CardContainer
	
	#for card_code in cards:
		#var card_instance = card.instantiate()
		#var texture = load("res://Assets/card_images/%s.png" % card_code)
		#if texture is CompressedTexture2D:
			#var image = texture.get_image()
			#image.resize(163, 240, Image.INTERPOLATE_TRILINEAR)
			#texture = ImageTexture.create_from_image(image)
		#card_instance.texture = texture
		#card_instance.card_code = card_code
		#card_container.add_child(card_instance)
		
	for card_code in cards:
		var card_data = cards[card_code]
		var texture_rect = TextureRect.new()
		var texture = load("res://Assets/card_images/%s.png" % card_code)
		if texture is CompressedTexture2D:
			var image = texture.get_image()
			image.resize(163, 240, Image.INTERPOLATE_TRILINEAR)
			texture = ImageTexture.create_from_image(image)
		texture_rect.texture = texture
		texture_rect.custom_minimum_size = Vector2(164, 230)
		card_container.add_child(texture_rect)
