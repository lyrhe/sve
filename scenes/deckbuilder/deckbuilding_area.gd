class_name Test extends Zone

# Initialise un deck vide
var cards: Deck = Deck.new()

# Récupère le label, la zone decklist et son propre scroll container
@export var shown_cards_label: Label
@export var deck_area: GridContainer
@export var scroll_container: ScrollContainer

# Constantes de taille pour l'expand + base de données + CardUI scene
const DECKBUILDER_CARD_SIZE := Vector2(125, 176)
const DECKBUILDER_CARD_SCALE := Vector2(1.09, 1.09)
const DECKBUILDER_CARD_POSITION := Vector2(71, 100)
const CARD_DATABASE_PATH := "res://assets/cards_database/cards_formatted.json"
const CARD_SCENE_PATH := "res://scenes/card/CardUi.tscn"

func _ready():
	# Désactive l'evolve deck
	evolve_deck = null
	# Charge la database et update le visuel
	load_card_database()
	display_cards()
	# Signal pour le nombre de cartes affichées
	update_visible_card_count()

func load_card_database():
	cards.load_cards(deserializer.load_deckbuilder(CARD_DATABASE_PATH))
	
func spawn_cardui(card: Card) -> Control:
	# Instancie l'UI et lui donne ses métadonnées
	var card_ui = load(CARD_SCENE_PATH).instantiate()
	card_ui.metadata = card
	# Ajoute la CardUi au container
	cards_container.add_child(card_ui)
	# Lui donne sa bigger_frame
	card_ui.bigger_frame = bigger_frame
	# Lui donne ses signaux
	card_ui.connect("visibility_changed", Callable(self, "_on_card_visibility_changed"))
	card_ui.move_to_deck.connect(send_to_deck)
	# Différents paramètres de taille et de position
	card_ui.collision_shape.shape.set_size(DECKBUILDER_CARD_SIZE)
	card_ui.collision_shape.set_position(DECKBUILDER_CARD_POSITION)
	card_ui.set_custom_minimum_size(DECKBUILDER_CARD_SIZE)
	card_ui.texture_rect.set_scale(DECKBUILDER_CARD_SCALE)
	card_ui.is_changing_zone.connect(replace_card)
	card_ui.switch_rarity.connect(switch_rarity_artwork)
	# Déactive l'attaque et la défense
	card_ui.atk_def.visible = false
	# Renvoie la card UI
	return card_ui
	
# Donne une card UI à chaque carte du "deck"
func display_cards():
	for card in cards.cards:
		spawn_cardui(card)

# Envoie la carte dans la zone du deck
func send_to_deck(card_ui):
	var card_data: Card = card_ui.metadata.duplicate()
	card_data.rarity_index = card_ui.metadata.rarity_index # preserve rarity explicitly
	var new_card_ui = load(CARD_SCENE_PATH).instantiate()
	new_card_ui.metadata = card_data
	new_card_ui.bigger_frame = bigger_frame
	new_card_ui.move_to_deck.disconnect(send_to_deck)
	deck_area.add_child(new_card_ui)
	set_artwork(new_card_ui)

# Remplace la carte qui vient de partir
func replace_card(card_ui):
	var card_data = card_ui.metadata as Card
	var index = cards_container.get_children().find(card_ui) 
	if index == -1:
		index = cards_container.get_child_count()
	await get_tree().process_frame
	var new_card_ui = spawn_cardui(card_data)
	cards_container.move_child.call(new_card_ui, index)

# Proc quand une carte change de statut visible/invisible
func _on_card_visibility_changed():
	update_visible_card_count()

# Update le label du nombre de cartes à l'écran
func update_visible_card_count():
	var count := 0
	for child in cards_container.get_children():
		if child is Control and child.is_visible_in_tree():
			count += 1
	shown_cards_label.text = "Visible Cards: %d" % count

# Empêche la génération de doublons dans la zone du deckbuilder
func _on_cards_child_entered_tree(node: Node) -> void:
	await get_tree().process_frame
	if node.atk_def.visible == true:
		node.queue_free()

func switch_rarity_artwork(card_ui):
	# Incrémente rarity_index, boucle à 0 si dépasse
	var rarities = card_ui.metadata.alternate_rarities
	card_ui.metadata.rarity_index = (card_ui.metadata.rarity_index + 1) % rarities.size()
	# Applique l'artwork correspondant à l'index
	set_artwork(card_ui)
	
func set_artwork(card_ui):
	var rarities = card_ui.metadata.alternate_rarities
	var index = card_ui.metadata.rarity_index
	card_ui.metadata.rarity_index = index
	# Change l'image selon le nouveau rarity_index
	var path = "user://cards/" + rarities[index] + ".png"
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		push_error("Failed to load image. Error: " + str(err))
		return
	var texture = ImageTexture.create_from_image(image)
	card_ui.texture_rect.texture = texture
