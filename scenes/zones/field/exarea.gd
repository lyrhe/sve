class_name ExArea extends Zone

# Renvoie une carte Evolved dans l'Evolve Deck
# Ajoute la version de base à la zone appropriée
func _on_cards_child_entered_tree(node: Node) -> void:
	if node.metadata.evolved == true:
		var evolved_clone = node.duplicate()
		$"../Evolve/CanvasLayer/ScrollContainer/Cards".add_child(evolved_clone)
		node.metadata = deserializer.load_card(node.metadata.base)
