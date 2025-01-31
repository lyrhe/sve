class_name Card
extends TextureRect

# Détermine le statut de base d'une carte qui spawn (immobile, stand)
var is_dragging = false
var state = "stand"
var original_parent: Node = null

@export var card_code: String = ""
@onready var ex_area = get_node("../../../CanvasExArea/ExArea")
@onready var field = get_node("../../../CanvasField/Field")
@onready var player_hand = get_node("../../../CanvasPlayerHand/PlayerHand")
@onready var graveyard = get_node("../../../Graveyard")
@onready var board = get_node("../../..")
const card = preload("res://Scenes/card.tscn")

# Gère le déplacement d'une carte, et renvoie la carte à son parent d'origine avec un clic droit
func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - size * 0.5
		if Input.is_action_just_pressed("right_mouse_click"):
			self.get_parent().remove_child(self)
			original_parent.add_child(self)
			is_dragging = false

# Gère les changements de statuts d'une carte
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		# Démarre le dragging et attribue un parent d'origine
		if Input.is_action_just_pressed('mouse_click'):
			stand()
			is_dragging = true
			original_parent = get_parent()
		# Dépose la carte en l'attribuant à un nouveau parent grâce à sa position
		# Renvoie la carte à son parent d'origine si la zone est pleine
		if Input.is_action_just_released('mouse_click') and is_dragging == true :
			is_dragging = false
			if ex_area and ex_area.get_rect().has_point(get_global_mouse_position()):
				if ex_area.get_child_count() < 5:
					reparent_card(ex_area)
					print("-------------------")
					print(self.name)
					if self.name in graveyard.graveyard:
						graveyard.graveyard.erase(self.name)
						print(graveyard.graveyard)
				elif ex_area.get_child_count() >= 5:
					self.get_parent().remove_child(self)
					original_parent.add_child(self)
					is_dragging = false
			elif field and field.get_rect().has_point(get_global_mouse_position()):
				if field.get_child_count() < 5:
					reparent_card(field)
				elif ex_area.get_child_count() >= 5:
					self.get_parent().remove_child(self)
					original_parent.add_child(self)
					is_dragging = false
			elif player_hand and player_hand.get_rect().has_point(get_global_mouse_position()):
				reparent_card(player_hand)
			elif graveyard and graveyard.get_rect().has_point(graveyard.to_local(get_global_mouse_position())):
				print(self.name)
				graveyard.graveyard.append(self.name)
				print(graveyard.graveyard)
				var texture = load("res://Assets/card_images/%s.png" % self.name)
				graveyard.set_texture(texture)
				graveyard.scale = Vector2(0.3, 0.3)
				var card_instance = card.instantiate()
				card_instance.texture = texture
				graveyard.add_child(card_instance)
				self.get_parent().remove_child(self)
				board.update_graveyard_display()
			else:
				pass
		# Incline la carte sur un clic droit si elle est stand
		if Input.is_action_just_pressed("right_mouse_click") and state == "stand":
			rest()
			return
		# Redresse la carte sur un clic droit si elle est rest
		if Input.is_action_just_pressed("right_mouse_click") and state == "rest":
			stand()
			return
			
# Attribue un nouveau parent à la carte
func reparent_card(new_parent: HBoxContainer) -> void:
	if new_parent:
		get_parent().remove_child(self)
		new_parent.add_child(self)
		self.position = Vector2.ZERO

# Redresse la carte
func stand():
	rotation_degrees = 0
	state = "stand"
	
# Incline la carte
func rest():
	rotation_degrees = 90
	state = "rest"
