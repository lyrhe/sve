class_name Field extends Zone

func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.type == "Spell" :
		node.reparent_to_previous_parent(node)
	elif node.metadata.evolved:
		if node.metadata.used:
			node.reparent_to_previous_parent(node)
		else:
			node.metadata.used = true
	elif cards_container.get_child_count() > 5:
		if not node.previous_parent == node.get_parent():
			var clone = node.duplicate()
			node.previous_parent.add_child(clone)
			node.queue_free()
