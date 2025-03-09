class_name Graveyard extends Zone

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved:
		var clone = node.duplicate()
		evolve_deck.add_child(clone)
		node.metadata = deserializer.load_card(node.metadata.base)
	if node.metadata.token:
		node.queue_free()
