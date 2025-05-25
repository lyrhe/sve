extends Button

@export var deck: GridContainer
@export var decklist: Label

func _on_pressed() -> void:
	for child in deck.get_children():
		child.queue_free()
	decklist.text = ""
