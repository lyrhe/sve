class_name ExArea extends Zone

# Renvoie une carte Evolved dans l'Evolve Deck
# Ajoute la version de base à la zone appropriée
func _on_cards_child_entered_tree(node: Node) -> void:
	if node.previous_parent:
		if node.previous_parent.get_parent().get_parent().get_parent().name == "Evolve":
			var evolved_clone = node.duplicate()
			$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
			node.queue_free()
			return
		if node.metadata.evolved == true:
			var evolved_clone = node.duplicate()
			$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
			node.metadata = deserializer.load_card(node.metadata.base)
	if cards_container.get_child_count() > 5:
		if not node.metadata.token:
			var clone = node.duplicate()
			cards_container.get_child(-1).previous_parent.add_child(clone)
		node.queue_free()
		
