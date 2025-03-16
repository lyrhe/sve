class_name Zone extends Control

# Signal émit quand clic droit sur une zone fermée.
signal toggle_visibility(zone: Zone)

# Preload la scène carte.
const CARD_UI_SCENE = preload("res://scenes/card/CardUi.tscn")

# Récupère le Container utilisé par chaque zone pour afficher les cartes.
@export var cards_container: Container
@onready var evolve_deck: Control = $"../Evolve/CanvasLayer/ScrollContainer/Cards"
@export var texture: TextureRect
@export var bigger_frame: CanvasLayer

# Initialise un deserializer
var deserializer = DeckDeserializer.new()

func add_card(card: CardUi):
	# Instancie une CardUi
	var new_child = load("res://scenes/card/CardUi.tscn").instantiate();
	# Connecte les signaux
	new_child.reparent_requested.connect(_on_card_reparent_requested)
	new_child.is_changing_zone.connect(on_card_changing_zone)
	# Transfère previous_parent et les metadata
	new_child.previous_parent = card.get_parent()
	new_child.metadata = card.metadata
	new_child.bigger_frame = bigger_frame
	# L'ajoute au container de la zone
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

func _update_texture() -> void:
	if cards_container.get_child_count() > 0:
		self.texture.texture = load("res://assets/cards/" + cards_container.get_child(-1).metadata.card_id + ".png")
	else:
		self.texture.texture = load("res://assets/card_back.jpg")
		
func _on_cards_child_order_changed() -> void:
	_update_texture()
	
func _exit_tree() -> void:
	if cards_container:
		cards_container.child_order_changed.disconnect(_on_cards_child_order_changed)

func _on_cards_child_entered_tree(node: Node) -> void:
	pass

func _on_player_hand_child_entered_tree(node: Node) -> void:
	pass

func _on_cards_child_exiting_tree(node: Node) -> void:
	pass

func on_card_changing_zone(card_ui: CardUi):
	pass
