extends Sprite2D

# Récupère le board et la main du joueur, preload la classe Card, initialise une liste pour stocker le deck
@export var board : Node
@export var player_hand : HBoxContainer
const card = preload("res://Scenes/card.tscn")
var player_deck : Array[String] = []

# TEST - Charge une decklist
func _ready() -> void:
	load_deck("res://Test/decklist.txt")

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
