class_name Card
extends TextureRect

signal on_drop(card: Card, parent: Node)

# Détermine le statut de base d'une carte qui spawn (immobile, stand, aucun parent d'origine)
@onready var is_dragging = false
@onready var original_parent: Node = null
@onready var dialog = find_parent("Board").find_child("ConfirmationDialog")
@onready var token = false
var state = "stand"
var evolved = false

# Permet d'identifier des cartes avec un nom identique
@export var card_code: String = ""
@export var previous_card_code: String = ""

func calc_previous_card_code():
	var parts = card_code.split("-")
	if parts.size() == 2:
		var num = int(parts[1]) - 1
		var new_num = "%03d" % num
		self.previous_card_code = parts[0] + '-' + str(new_num)

# Récupère la node board
@onready var hover_display = get_tree().get_root().find_child("HoverDisplay", true, false)

# Gère le déplacement d'une carte et renvoie la carte à son parent d'origine avec un clic droit
func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - size * 0.5
		if Input.is_action_just_pressed("right_mouse_click"):
			get_parent().remove_child(self)
			original_parent.add_child(self)
			is_dragging = false
	if state == "rest":
		rotation_degrees = 90
	else:
		rotation_degrees == 0

# Gère les changements de statut d'une carte
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('mouse_click'):
			if state == "rest":
				stand_rest()
			is_dragging = true
			_z_index(self)
			original_parent = get_parent()
		if Input.is_action_just_released('mouse_click') and is_dragging == true :
			is_dragging = false
			on_drop.emit(self, original_parent)
			_z_index(self)
			if self.token and self.get_parent().name == "PlayerHand":
				self.get_parent().remove_child(self)
		if Input.is_action_just_pressed("right_mouse_click"):
			if get_parent().name == "Field" or get_parent().name == "ExArea":
				stand_rest()
				return
		if Input.is_action_just_pressed("wheel_click"):
			get_parent().move_child(self, -1)
			
# Attribue un nouveau parent à la carte
func reparent_card(new_parent: Node, x) -> void:
	if self.token and self.get_parent().name == "TokensDrawer":
		var y = self.get_index()
		get_parent().remove_child(self)
		new_parent.add_child(self)
		x = self.duplicate()
		x.token = true
		original_parent.add_child(x)
		original_parent.move_child(x, y)
		x.on_drop.connect(x.get_parent().get_parent().get_parent().get_parent().check_position)
		position = Vector2.ZERO
		return
	if new_parent:
		get_parent().remove_child(self)
		new_parent.add_child(self)
		new_parent.get_child(-1).evolved = x
		if new_parent.name == "Deck":
			dialog.canceled.connect(dialog_canceled.bind(new_parent))
			dialog.confirmed.connect(dialog_confirmed.bind(new_parent))
			dialog.visible = not dialog.visible
		position = Vector2.ZERO
		
func dialog_canceled(new_parent):
	new_parent.move_child(new_parent.get_child(-1), -1)

func dialog_confirmed(new_parent): 
	new_parent.move_child(new_parent.get_child(-1), 0)

# Stand ou rest le carte
func stand_rest():
	if state == "rest":
		rotation_degrees = 0
		state = "stand"
	elif state == "stand":
		state = "rest"

func _on_mouse_entered() -> void:
	if hover_display:
		hover_display.texture = texture
		hover_display.size = texture.get_size() * 0.7
		var viewport_rect = get_viewport_rect()
		hover_display.position = Vector2(0, 0)
		hover_display.show()

func _on_mouse_exited() -> void:
	if hover_display:
		hover_display.hide()
		
func _z_index(card):
	if is_dragging == true:
		if get_parent().get_parent() is not CanvasLayer:
			get_parent().get_parent().get_parent().layer = 2
			card.z_index = 2
		else:
			get_parent().get_parent().layer = 2
			card.z_index = 2
	elif is_dragging == false:
		if get_parent().get_parent() is not CanvasLayer:
			get_parent().get_parent().get_parent().layer = 1
			card.z_index = 1
		else:
			get_parent().get_parent().layer = 1
			card.z_index = 1
	
