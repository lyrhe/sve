class_name Zone extends Control

const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")

@export var cards_container: Container

func add_card(card: CardUi):
	var new_child = CARD_UI_SCENE.instantiate();
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.card_id = card.card_id
	cards_container.add_child(new_child)

func _on_card_reparent_requested(card: CardUi):
	print("Reparenting card: " + str(card) + " to " + str(self))
	cards_container.add_card(card.card_id)
	card.queue_free()
	
func toggle_cards_list():
	if not cards_container:
		return
	cards_container.visible = !cards_container.visible
