extends Button

@export var deck_container: Control


func _on_pressed() -> void:
	$FileDialog.popup_centered()

func _on_file_dialog_file_selected(path: String) -> void:
	#var decklist = deserializer.load_cards_list(path, "res://assets/cards_database/total.json")
	#deck.load_cards(decklist[0])
	#for card in decklist[1]:
		#_spawn_card_ui(card, evolve_deck)

	#var file = FileAcceses.open(path, FileAccess.WRITE)
	#
	#
	#for child in deck_container.cards_container.get_children():
		#file.store_line(child.metadata.card_id)
	#file.close()
	
	pass
