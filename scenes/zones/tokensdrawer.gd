class_name TokensDrawer extends Zone

func _ready() -> void:
	$DropZone/CollisionShape2D.disabled = true
	for card in deserializer.load_deck("res://assets/test_tokens.txt", "res://assets/test_tokens.json"):
		var new_child = CARD_UI_SCENE.instantiate();
		new_child.metadata = card
		new_child.card_id = new_child.metadata.card_id
		cards_container.add_child(new_child)

func _on_tokens_pressed() -> void:
	self.get_child(1).visible = not self.get_child(1).visible
