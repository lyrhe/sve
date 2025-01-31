extends Node2D

# Initialise selected_deck et récupère la main et le deck du joueur
var selected_deck: String = ""
@export var player_hand : HBoxContainer
@export var deck : Sprite2D

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
