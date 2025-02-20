class_name Zone extends Control

signal toggle_visibility(zone: Zone)

const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")

@export var cards_container: Container

var deserializer = DeckDeserializer.new()

func add_card(card: CardUi):
	var new_child = CARD_UI_SCENE.instantiate();
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.card_id = card.card_id
	new_child.previous_parent = card.previous_parent
	new_child.metadata = card.metadata
	new_child.card_id = card.metadata.card_id
	cards_container.add_child(new_child)

func _on_card_reparent_requested(card: CardUi):
	print("Reparenting card: " + str(card) + " to " + str(self))
	add_card(card)
	card.queue_free()
	
func toggle_cards_list(visible: bool):
	if not cards_container:
		return
	cards_container.get_parent().get_parent().visible = visible

func _on_drop_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("right_mouse_click"):
		if cards_container.get_parent().get_parent().visible == true:
			toggle_cards_list(false)
		else:
			toggle_visibility.emit(self)

func _on_cards_child_entered_tree(node: Node) -> void:
	pass

func _on_player_hand_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
