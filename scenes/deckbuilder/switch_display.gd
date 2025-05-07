extends Button

func _on_pressed() -> void:
	print("zob")
	$"../../DeckBuildingArea2/CanvasLayer".visible = not $"../../DeckBuildingArea2/CanvasLayer".visible
	print("Pictures are now visible: ", $"../../DeckBuildingArea2/CanvasLayer".visible)
	$"../../DeckBuildingArea2/Decklist".visible = not $"../../DeckBuildingArea2/Decklist".visible
	print("Text is now visible: ", $"../../DeckBuildingArea2/Decklist".visible)
