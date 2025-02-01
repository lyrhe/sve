class_name Card
extends TextureRect

# Détermine le statut de base d'une carte qui spawn (immobile, stand, aucun parent d'origine)
@onready var is_dragging = false
@onready var state = "stand"
@onready var original_parent: Node = null

# Permet d'identifier des cartes avec un nom identique
@export var card_code: String = ""

# Récupère la node board
@onready var board = get_tree().get_root().get_node("Board") 

# Gère le déplacement d'une carte et renvoie la carte à son parent d'origine avec un clic droit
func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - size * 0.5
		if Input.is_action_just_pressed("right_mouse_click"):
			get_parent().remove_child(self)
			original_parent.add_child(self)
			is_dragging = false

# Gère les changements de statut d'une carte
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('mouse_click'):
			if state == "rest":
				stand_rest()
			is_dragging = true
			original_parent = get_parent()
		if Input.is_action_just_released('mouse_click') and is_dragging == true :
			is_dragging = false
			board.check_position(self, original_parent)
		if Input.is_action_just_pressed("right_mouse_click"):
			if get_parent().name == "Field" or get_parent().name == "ExArea":
				stand_rest()
				return
			
# Attribue un nouveau parent à la carte
func reparent_card(new_parent) -> void:
	if new_parent:
		get_parent().remove_child(self)
		new_parent.add_child(self)
		position = Vector2.ZERO

# Stand ou rest le carte
func stand_rest():
	if state == "rest":
		rotation_degrees = 0
		state = "stand"
	elif state == "stand":
		rotation_degrees = 90
		state = "rest"
