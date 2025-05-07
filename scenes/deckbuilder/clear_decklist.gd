extends Button

func _on_pressed() -> void:
	for child in $"../../DeckBuildingArea2/CanvasLayer/ScrollContainer/Cards".get_children():
		print(child)
		child.queue_free()
	$"../../DeckBuildingArea2/Decklist".text = ""
