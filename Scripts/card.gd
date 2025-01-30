class_name Card
extends TextureRect

var is_dragging = false
var state = "stand"
var original_parent: Node = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - size * 0.5
		if Input.is_action_just_pressed("right_mouse_click"):
			self.get_parent().remove_child(self)
			original_parent.add_child(self)
			is_dragging = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('mouse_click'):
			is_dragging = true
			original_parent = get_parent()
		if Input.is_action_just_released('mouse_click') and is_dragging == true :
			is_dragging = false
			var ex_area = get_node("../../../CanvasExArea/ExArea")
			var field = get_node("../../../CanvasField/Field")
			var player_hand = get_node("../../../CanvasPlayerHand/PlayerHand")
			if ex_area and ex_area.get_rect().has_point(get_global_mouse_position()):
				if ex_area.get_child_count() < 5:
					reparent_card(get_node("../../../CanvasExArea/ExArea"))
				elif ex_area.get_child_count() >= 5:
					self.get_parent().remove_child(self)
					original_parent.add_child(self)
					is_dragging = false
			elif field and field.get_rect().has_point(get_global_mouse_position()):
				reparent_card(get_node("../../../CanvasField/Field"))
			elif player_hand and player_hand.get_rect().has_point(get_global_mouse_position()):
				reparent_card(get_node("../../../CanvasPlayerHand/PlayerHand"))
			else:
				pass
		if Input.is_action_just_pressed("right_mouse_click") and state == "stand":
			rotation_degrees = 90
			state = "rest"
			return
		if Input.is_action_just_pressed("right_mouse_click") and state == "rest":
			rotation_degrees = 0
			state = "stand"
			return
			
			
func reparent_card(new_parent: HBoxContainer) -> void:
	if new_parent:
		get_parent().remove_child(self)
		new_parent.add_child(self)
		self.position = Vector2.ZERO
