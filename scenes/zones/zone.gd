class_name Zone extends Control

# Signal émit quand clic droit sur une zone fermée.
signal toggle_visibility(zone: Zone)

# Preload la scène carte.
const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")

# Récupère le Container utilisé par chaque zone pour afficher les cartes.
@export var cards_container: Container

# Initialise un deserializer
var deserializer = DeckDeserializer.new()

# Instancie une carte, connecte son signal à _on_card_reparent_requested,
# transmet son parent précédent et ses métadata avant de l'ajouter au container.
# Utilisée pour renvoyer une carte quand dropped dans une zone illégale.
func add_card(card: CardUi):
	var new_child = load("res://scenes/card/CardUi.tscn").instantiate();
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.previous_parent = card.previous_parent
	new_child.metadata = card.metadata
	cards_container.add_child(new_child)

func _on_card_reparent_requested(card: CardUi):
	print("Reparenting card: " + str(card) + " to " + str(self))
	add_card(card)
	card.queue_free()

# Ouvre le container qui a émit le signal et ferme les autres
func toggle_cards_list(visible: bool):
	if not cards_container:
		return
	cards_container.get_parent().get_parent().visible = visible

# Clic-droit sur une zone pour la fermer si elle est ouverte.
# Sinon, émet le signal pour s'ouvrir et fermer les autres.
func _on_drop_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("right_mouse_click"):
		if cards_container.get_parent().get_parent().visible == true:
			toggle_cards_list(false)
		else:
			toggle_visibility.emit(self)

func _on_cards_child_entered_tree(node: Node) -> void:
	pass

func _on_player_hand_child_entered_tree(node: Node) -> void:
	pass

func _on_cards_child_exiting_tree(node: Node) -> void:
	#var id = node.metadata.card_id
	#var index = node.get_index()
	#print(node.get_index())
	#self.deck.cards.pop_at(index)
	pass

func _on_canvas_layer_visibility_changed() -> void:
	if cards_container.visible:
		for child in cards_container.get_children():
			child.visible = true
