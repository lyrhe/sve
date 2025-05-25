extends Button

@export var deck_canvas: CanvasLayer
@export var decklist: Label

func _on_pressed() -> void:
	deck_canvas.visible = not deck_canvas.visible
	decklist.visible = not decklist.visible
