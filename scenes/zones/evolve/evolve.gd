class_name Evolve extends Zone

var evolve_deck: Deck

# Empêche une carte non-Evolved d'entrer dans l'Evolve Deck
func _on_cards_child_entered_tree(node: Node) -> void:
	if not node.metadata.evolved:
		var evolved_clone = node.duplicate()
		node.previous_parent.add_child(evolved_clone)
		node.queue_free()
		
