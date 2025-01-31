extends Sprite2D

# Récupère le board et la main du joueur, preload la classe Card, initialise une liste pour stocker le deck
@export var board : Node
@export var player_hand : HBoxContainer
const card = preload("res://Scenes/card.tscn")
var player_deck : Array[String] = []
@onready var deck_grid = get_node("../CanvasDeck/ScrollContainer/Deck")

# TEST - Charge une decklist
func _ready() -> void:
	load_deck("res://Test/decklist.txt")
	populate_deck_grid()

# Parse les lignes d'un fichier texte, en ressort une liste et mélange
func load_deck(deck_file_path: String) -> void:
	var file = FileAccess.open(deck_file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open deck file: " + deck_file_path)
		return
	player_deck.clear()
	var lines := file.get_as_text().split("\n", false)
	player_deck.append_array(lines)
	player_deck.shuffle()

# Ajoute une carte à la main du joueur avec un clic gauche sur le deck
func _on_deck_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			player_hand.force_draw(1)
	if Input.is_action_just_pressed("right_mouse_click") and deck_grid.visible == false:
		deck_grid.visible = true
	elif Input.is_action_just_pressed("right_mouse_click") and deck_grid.visible == true:
		deck_grid.visible = false
		
func populate_deck_grid():
	for n in player_deck:
		var card_instance = card.instantiate()
		var card_code = n
		var texture_path = "res://Assets/card_images/%s.png" % n
		var texture = load(texture_path)
		card_instance.texture = texture
		card_instance.card_code = n
		deck_grid.add_child(card_instance, true)
	var zob : Array[String] = []
	for n in deck_grid.get_children():
		zob.append(n.card_code)
	

func _on_deck_visibility_changed() -> void:
	if deck_grid.visible == true:
		print(deck_grid.get_child_count())
		print(player_deck.size())
		if deck_grid.get_child_count() > player_deck.size(): 
			if deck_grid.get_child_count() > 0 :
				for n in deck_grid.get_children():
					print("zob")
					deck_grid.remove_child(n)
				print(player_deck)
				for n in player_deck:
					print(n)
					var card_instance = card.instantiate()
					var card_code = n
					var texture_path = "res://Assets/card_images/%s.png" % n
					var texture = load(texture_path)
					card_instance.texture = texture
					card_instance.name = n
					deck_grid.add_child(card_instance)
		if deck_grid.get_child_count() < player_deck.size():
			if deck_grid.get_child_count() > 0 :
				player_deck.clear()
				print(player_deck)
				for n in deck_grid.get_children():
					player_deck.append(n.card_code)
				print(player_deck)
		player_deck.shuffle()

func _on_deck_child_exiting_tree(node: Node) -> void:
	#if deck_grid.get_child_count() > 0:
		#player_deck.erase(node.card_code)
	pass
