class_name ExArea extends Zone

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved:
		var evolved_clone = node.duplicate()
		evolve_deck.add_child(evolved_clone)
		node.metadata = deserializer.load_card(node.metadata.base)
	elif cards_container.get_child_count() > 5:
		if not node.previous_parent == node.get_parent():
			var clone = node.duplicate()
			node.previous_parent.add_child(clone)
			node.queue_free()
