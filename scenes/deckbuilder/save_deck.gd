extends Button

@export var deck_container: Control

func _on_pressed() -> void:
	$FileDialog.popup_centered()

func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file: %s" % path)
		return
	
	for child in deck_container.cards_container.get_children():
		var line := "%s/%d\n" % [child.metadata.card_id, child.metadata.rarity_index]
		file.store_string(line)

	file.close()
