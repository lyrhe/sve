class_name TokensDrawer extends Zone

# Déclare une ressource Deck
var tokens_deck: Deck = Deck.new()

# Récupère le tiroir et la drop zone
@onready var drawer = $CanvasLayer
@onready var drop_zone = $DropZone/CollisionShape2D

# Deserialize la liste de tokens, instancie un Deck, ajoute les Cards,
# désactive la zone de colision, ajoute une CardUI à chaque Card
func _ready() -> void:
	tokens_deck.load_cards(deserializer.load_cards_list("res://assets/tokens_list.txt", "res://assets/cards_database/tokens.json")[0])
	drop_zone.disabled = true
	spawn_cards(tokens_deck.cards)

# Si le tiroir est visible : le rend invisible et stop la méthode.
# Sinon, le rend visible et emet de quoi rendre les autres invisibles.
func _on_tokens_pressed() -> void:
	if drawer.visible:
		drawer.visible = not drawer.visible
		return
	drawer.visible = not drawer.visible
	toggle_visibility.emit(self)

# Remplace un token qui sort du tiroir
func _on_cards_child_exiting_tree(node: Node) -> void:
	var index = node.get_index()
	var token_replacement = node.duplicate()
	cards_container.add_child.call_deferred(token_replacement)
	cards_container.move_child.call_deferred(token_replacement, index)
	token_replacement.bigger_frame = bigger_frame

# Ajoute une CardUI à chaque Card du deck
func spawn_cards(cards: Array[Card]):
	for card in cards:
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.bigger_frame = bigger_frame
		cards_container.add_child.call_deferred(new_child)
