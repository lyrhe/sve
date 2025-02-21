class_name TokensDrawer extends Zone

func _ready() -> void:
	$DropZone/CollisionShape2D.disabled = true
	for card in deserializer.load_deck("res://assets/tokens_list.txt", "res://assets/cards_database/tokens.json"):
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)

func _on_tokens_pressed() -> void:
	if self.get_child(1).visible:
		self.get_child(1).visible = not self.get_child(1).visible
		return
	self.get_child(1).visible = not self.get_child(1).visible
	toggle_visibility.emit(self)

func _on_cards_child_exiting_tree(node: Node) -> void:
	var index = node.get_index()
	var zeub = node.duplicate()
	cards_container.add_child.call_deferred(zeub)
	cards_container.move_child.call_deferred(zeub, index)
	
