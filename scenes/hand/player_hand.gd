class_name PlayerHand extends Zone

func _ready() -> void:
	$"../Deck".deck.draw_card.connect(_on_card_drawn)

# Renvoie une carte Evolved dans l'Evolve Deck
# Ajoute la version de base à la zone appropriée
# Supprime un token
func _on_player_hand_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved == true:
		var evolved_clone = node.duplicate()
		$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
		node.metadata = deserializer.load_card(node.metadata.base)
	if node.metadata.token == true:
		node.queue_free()
		
func spawn_card(card: Card):
	var new_child: CardUi = CARD_UI_SCENE.instantiate();
	new_child.metadata = card
	cards_container.add_child(new_child)

func _on_card_drawn(card):
	spawn_card(card)
