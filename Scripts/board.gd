extends Node2D

# Initialise selected_deck et récupère la main et le deck du joueur
var selected_deck: String = ""
@export var player_hand : HBoxContainer
@export var deck : Sprite2D

@onready var graveyard_drop_location = get_node("Graveyard")
@onready var graveyard = get_node("CanvasGraveyard/Graveyard")
@onready var last_child = ""

# Ouvre le menu pour charger un deck - @LoadDeckButton
func _on_menu_button_pressed() -> void:
	$LoadDeckButton/FileDialog.popup_centered()

# Supprime les cartes de la main - @ClearHand
func _on_menu_button_2_pressed() -> void:
	for card in player_hand.get_children():
		player_hand.remove_child(card)
		card.queue_free()

# Récupère le chemin du deck sélectionné pour la charger via la fonction load_deck() de deck.gd
func _on_file_dialog_file_selected(path: String) -> void:
	selected_deck = path
	deck.load_deck(path)

func update_graveyard_drop_location_texture():
	if graveyard.get_child_count() > 0 :
		last_child = graveyard.get_child(graveyard.get_child_count()-1).name
	print(graveyard.get_child_count())
	var texture = load("res://Assets/card_images/%s.png" % last_child)
	graveyard_drop_location.set_texture(texture)
	graveyard_drop_location.scale = Vector2(0.3, 0.3)
	if graveyard.get_child_count() == 0:
		var default_texture = load("res://Assets/card_back.jpg")
		graveyard_drop_location.set_texture(default_texture)
		graveyard_drop_location.scale = Vector2(0.7, 0.7)

func _on_graveyard_child_order_changed() -> void:
	update_graveyard_drop_location_texture()
