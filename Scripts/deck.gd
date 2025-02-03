extends Sprite2D

# Récupère le board et la main du joueur, preload la classe Card, initialise une liste pour stocker le deck
@export var player_hand : HBoxContainer
@export var deck_grid : GridContainer
@export var board: Board
@export var view_top_dialog: TopNAcceptDialog

const card = preload("res://Scenes/card.tscn")

# TEST - Autoload une decklist
func _ready() -> void:
	load_deck("res://Test/decklist.txt")
	
	view_top_dialog.on_dialog_confirmed.connect(self.on_top_cards_confirmed)
	
# Récupère le chemin du deck sélectionné pour la charger via la fonction load_deck() de deck.gd
func _on_file_dialog_file_selected(path: String) -> void:
	load_deck(path)

# Parse les lignes d'un fichier texte, en ressort une liste et mélange
func load_deck(deck_file_path: String) -> void:
	for n in deck_grid.get_children():
		deck_grid.remove_child(n)
		n.queue_free()
	var file = FileAccess.open(deck_file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open deck file: " + deck_file_path)
		return
	var lines := file.get_as_text().split("\n", false)
	var cards := []
	for n in lines :
		var card_instance = card.instantiate()
		var texture_path = "res://Assets/card_images/%s.png" % n
		var card_texture = load(texture_path)
		card_instance.texture = card_texture
		card_instance.card_code = n
		card_instance.on_drop.connect(board.check_position)
		cards.append(card_instance)
	cards.shuffle()
	for card_instance in cards:
		deck_grid.add_child(card_instance, true)

# Mélange le deck en récupérant les cartes actuellement dans le deck dans une liste, shuffle() puis repopulate
func shuffle_deck():
	var cards := []
	for n in deck_grid.get_children():
		cards.append(n.card_code)
	cards.shuffle()
	for n in deck_grid.get_children():
		deck_grid.remove_child(n)
		n.queue_free()
	for n in cards:
		var card_instance = card.instantiate()
		var texture_path = "res://Assets/card_images/%s.png" % n
		var card_texture = load(texture_path)
		card_instance.texture = card_texture
		card_instance.card_code = n
		deck_grid.add_child(card_instance, true)

# Ajoute une carte à la main du joueur avec un clic gauche sur le deck
func _on_deck_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			player_hand.force_draw(1)
	if Input.is_action_just_pressed("right_mouse_click"):
		deck_grid.visible = not deck_grid.visible
	if Input.is_action_just_pressed(("wheel_click")):
		var zeub = 4
		deck_grid.visible = not deck_grid.visible
		for n in zeub:
			deck_grid.get_child(n).visible = not deck_grid.get_child(n).visible
		for n in deck_grid.get_children():
			n.visible = not n.visible

# Shuffle à chaque fois que le deck est ouvert
func _on_deck_visibility_changed() -> void:
	if deck_grid.visible == true:
		shuffle_deck()
		
func on_top_cards_confirmed(top_n: int):
	for card_index in range(0, deck_grid.get_child_count()):
		var child = deck_grid.get_child(card_index)
		child.visible = (card_index < top_n)
