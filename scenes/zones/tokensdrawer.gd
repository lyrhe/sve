class_name TokensDrawer extends Zone

func _ready() -> void:
	$DropZone/CollisionShape2D.disabled = true
	var new_child = CARD_UI_SCENE.instantiate();
	new_child.card_id = "BP01-T05"
	new_child.metadata = deserializer.load_card(new_child.card_id)
	cards_container.add_child(new_child)

func _on_tokens_pressed() -> void:
	self.get_child(1).visible = not self.get_child(1).visible
