class_name Test2 extends Zone

func _on_button_2_pressed() -> void:
	var file_path = "res://decklists/zeub.txt"
	var file = FileAccess.open(file_path, FileAccess.WRITE)

	for child in cards_container.get_children():
		file.store_line(child.metadata.card_id)
	file.close()

func _on_cards_child_entered_tree(node: Node) -> void:
	#print("when entering:", $"../DeckBuildingArea".moved_card_index)
	node.get_child(1).visible = false
	node.set_custom_minimum_size(Vector2(125, 176))
	node.get_child(0).set_scale(Vector2(1.09, 1.09))
	if node.previous_parent == node.get_parent():
		node.queue_free()
	$Decklist.transform_decklist()
	
	#var replacement = node.duplicate()
	#replacement.bigger_frame = bigger_frame
	#$"../DeckBuildingArea/CanvasLayer/ScrollContainer/Cards".add_child(replacement)
	#$"../DeckBuildingArea/CanvasLayer/ScrollContainer/Cards".move_child(replacement, $"../DeckBuildingArea".moved_card_index)
	pass


func _on_cards_child_exiting_tree(node: Node) -> void:
	node.queue_free()
