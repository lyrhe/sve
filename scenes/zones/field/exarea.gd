class_name ExArea extends Zone

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved == true:
		print("Moving to Evolve Deck")
		var evolved_clone = node.duplicate()
		$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
		node.metadata = deserializer.load_card(node.metadata.base)
		node.card_id = node.metadata.card_id
