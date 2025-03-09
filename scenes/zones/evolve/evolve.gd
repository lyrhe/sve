class_name Evolve extends Zone

# Empêche une carte non-Evolved d'entrer dans l'Evolve Deck
func _on_cards_child_entered_tree(node: Node) -> void:
	if not node.metadata.evolved:
		var clone = node.duplicate()
		node.previous_parent.add_child(clone)
		node.queue_free()

func _on_cards_child_order_changed() -> void:
	if cards_container.get_child(-1).metadata.used:
		_update_texture()
