class_name PlayerHand extends Zone

func _ready() -> void:
	$"../Deck".deck.draw_card.connect(_on_card_drawn)

func _on_player_hand_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved:
		var clone = node.duplicate()
		evolve_deck.add_child(clone)
		node.metadata = deserializer.load_card(node.metadata.base)
	if node.metadata.token:
		node.queue_free()
		
func spawn_card(card: Card):
	var new_child: CardUi = CARD_UI_SCENE.instantiate();
	new_child.metadata = card
	new_child.bigger_frame = bigger_frame
	cards_container.add_child(new_child)
	
func _on_card_drawn(card):
	spawn_card(card)

func add_card(card: CardUi):
	# Instancie une CardUi
	var new_child = load("res://scenes/card/CardUi.tscn").instantiate();
	# Connecte les signaux
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.is_changing_zone.connect(on_card_changing_zone)
	# Transfère previous_parent et les metadata
	new_child.previous_parent = card.get_parent()
	new_child.metadata = card.metadata
	new_child.bigger_frame = bigger_frame
	# L'ajoute au container de la zone
	cards_container.add_child(new_child)
