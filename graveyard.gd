class_name Graveyard extends Zone

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved == true:
		var evolved_clone = node.duplicate()
		$"../Evolve/CanvasLayer/Cards".add_child(evolved_clone)
		node.metadata = deserializer.load_card(node.metadata.base)
		node.card_id = node.metadata.card_id
	if node.metadata.token == true:
		print("Deleting token")
		node.queue_free()
