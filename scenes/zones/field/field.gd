extends Zone

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.type == "Spell" :
		var evolved_clone = node.duplicate()
		node.previous_parent.add_child(evolved_clone)
		node.queue_free()
	if node.metadata.evolved == true:
		if node.metadata.used == true:
			var evolved_clone = node.duplicate()
			$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
			node.queue_free()
		else:
			node.metadata.used = true
