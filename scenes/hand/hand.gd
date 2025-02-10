class_name Hand extends HBoxContainer

const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")

func _ready() -> void:
	add_card("BP01-001")
	add_card("BP01-002")

func add_card(card_id: String):
	var new_child = CARD_UI_SCENE.instantiate();
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.card_id = card_id
	add_child(new_child)

func _on_card_reparent_requested(card: CardUi):
	print("Reparenting card: " + str(card) + " to " + str(self))
	add_card(card.card_id)
	card.queue_free()
