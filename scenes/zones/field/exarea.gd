class_name ExArea extends Zone

@export var evolve: Evolve

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved:
		print("evolved card sent to ex area")
		evolve.add_card(node)
		node.metadata = deserializer.load_card(node.metadata.base)
	elif cards_container.get_child_count() > 5:
		if not node.previous_parent == node.get_parent():
			var clone = node.duplicate()
			node.previous_parent.add_child(clone)
			node.queue_free()

func add_card(card: CardUi):
	# Instancie une CardUi
	var new_child = load("res://scenes/card/CardUi.tscn").instantiate();
	# Connecte les signaux
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.is_changing_zone.connect(on_card_changing_zone)
	# Transfère previous_parent et les metadata
	new_child.previous_parent = card.get_parent()
	new_child.metadata = card.metadata
	# L'ajoute au container de la zone
	cards_container.add_child(new_child)
	# Préserve les changements de stats et les compteurs spéciaux
	if not card.metadata.evolved:
		new_child.atk.text = card.atk.text
		new_child.def.text = card.def.text
	new_child.counters.text = card.counters.text
