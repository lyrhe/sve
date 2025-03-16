class_name Field extends Zone

@export var board: Board

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.type == "Spell" :
		var clone = node.duplicate()
		node.previous_parent.add_child(clone)
		node.queue_free()
	elif node.metadata.evolved:
		if node.metadata.used:
			var clone = node.duplicate()
			evolve_deck.add_child(clone)
			node.queue_free()
		else:
			node.metadata.used = true
	elif cards_container.get_child_count() > 5:
		if not node.previous_parent == node.get_parent():
			var clone = node.duplicate()
			node.previous_parent.add_child(clone)
			node.queue_free()
	elif node.metadata.type == "Follower":
		node.evolve_deck = evolve_deck
		node.field = self.cards_container

func add_card(card: CardUi):
	# Instancie une CardUi
	var new_child = load("res://scenes/card/CardUi.tscn").instantiate();
	# Connecte les signaux
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.is_changing_zone.connect(on_card_changing_zone)
	new_child.on_spawn_menu.connect(board._on_spawn_menu)
	# Transfère previous_parent et les metadata
	new_child.previous_parent = card.get_parent()
	new_child.metadata = card.metadata
	new_child.bigger_frame = bigger_frame
	# L'ajoute au container de la zone
	cards_container.add_child(new_child)
	# Préserve les changements de stats et les compteurs spéciaux
	new_child.atk.text = card.atk.text
	new_child.def.text = card.def.text
	new_child.counters.text = card.counters.text
