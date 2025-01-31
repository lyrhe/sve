extends Node2D

# Initialise selected_deck et récupère la main et le deck du joueur
var selected_deck: String = ""
@export var player_hand : HBoxContainer
@export var deck : Sprite2D

@onready var graveyard = $Graveyard  # Adjust path if needed
@onready var graveyard_display = $GraveyardDisplay  # Adjust path
@onready var graveyard_container = $CanvasGraveyard/GraveyardDisplay

var card_scene = preload("res://Scenes/card.tscn")


func update_graveyard_display():
	if not graveyard or not graveyard_container:
		return

	#for child in graveyard_container.get_children():
		#graveyard.graveyard.append(child.name)
	
	for child in graveyard_container.get_children():
		graveyard_container.remove_child(child)

	# Get textures and create TextureRects
	var card_data_list = graveyard.graveyard
	for card_data in card_data_list:
		var card_instance = card_scene.instantiate()
		
		var texture_path = "res://Assets/card_images/" + card_data + ".png"
		var texture = load(texture_path)
			
		graveyard_container.add_child(card_instance)
		card_instance.set_texture(texture)
		card_instance.name = card_data
		
		print("Graveyard card added:", card_instance.name)
		
	if graveyard_container.get_child_count() == 0:
		graveyard.texture = null

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

#func _on_graveyard_display_child_exiting_tree(node: Node) -> void:
	#graveyard.graveyard.erase(node.name)
	#update_graveyard_display()
