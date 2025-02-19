class_name Hand extends HBoxContainer

const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")

var deserializer = DeckDeserializer.new()

func _ready() -> void:
	pass
	
func add_card(card_id: String):
	var new_child = CARD_UI_SCENE.instantiate();
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.card_id = card_id
	new_child.metadata = deserializer.load_card(card_id)
	print("Adding card to Hand with metadata:", new_child.metadata)
	add_child(new_child)

func _on_card_reparent_requested(card: CardUi):
	print("Reparenting card: " + str(card) + " to " + str(self))
	add_card(card.card_id)
	card.queue_free()
