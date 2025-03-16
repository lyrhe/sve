class_name Test2 extends Zone

func _on_button_2_pressed() -> void:
	var file_path = "res://decklists/zeub.txt"
	var file = FileAccess.open(file_path, FileAccess.WRITE)

	for child in cards_container.get_children():
		file.store_line(child.metadata.card_id)
	file.close()
