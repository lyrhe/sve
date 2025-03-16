extends Button

@export var deck_container: Control

func _on_pressed() -> void:
	$FileDialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	for child in deck_container.cards_container.get_children():
		file.store_line(child.metadata.card_id)
	file.close()
	pass
