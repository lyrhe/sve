extends Node2D

# Ouvre le menu pour charger un deck - @LoadDeckButton
func _on_menu_button_pressed() -> void:
	$LoadDeckButton/FileDialog.popup_centered()

func update_graveyard_drop_location_texture():
	var last_child = ""
	if $CanvasSidebarR/ScrollContainer/Graveyard.get_child_count() == 0:
		return
	if $CanvasSidebarR/ScrollContainer/Graveyard.get_child_count() > 0 :
			last_child = $CanvasSidebarR/ScrollContainer/Graveyard.get_child($CanvasSidebarR/ScrollContainer/Graveyard.get_child_count()-1).card_code
	var texture = load("res://Assets/card_images/%s.png" % last_child)
	$Graveyard.set_texture(texture)
	$Graveyard.scale = Vector2(0.3, 0.3)
	if $CanvasSidebarR/ScrollContainer/Graveyard.get_child_count() == 0:
		var default_texture = load("res://Assets/card_back.jpg")
		$Graveyard.set_texture(default_texture)
		$Graveyard.scale = Vector2(0.7, 0.7)

func _on_graveyard_child_order_changed() -> void:
	update_graveyard_drop_location_texture()

func check_position(card, original_parent):
	if $CanvasExArea/ExArea and $CanvasExArea/ExArea.get_rect().has_point(get_global_mouse_position()):
		if $CanvasExArea/ExArea.get_child_count() < 5:
			card.reparent_card($CanvasExArea/ExArea)
		elif $CanvasExArea/ExArea.get_child_count() >= 5:
			card.get_parent().remove_child(card)
			original_parent.add_child(card)
			card.is_dragging = false
	elif $CanvasField/Field and $CanvasField/Field.get_rect().has_point(get_global_mouse_position()):
		if $CanvasField/Field.get_child_count() < 5:
			card.reparent_card($CanvasField/Field)
		elif $CanvasField/Field.get_child_count() >= 5:
			card.get_parent().remove_child(card)
			original_parent.add_child(card)
			card.is_dragging = false
	elif $CanvasPlayerHand/PlayerHand and $CanvasPlayerHand/PlayerHand.get_rect().has_point(get_global_mouse_position()):
		card.reparent_card($CanvasPlayerHand/PlayerHand)
	elif $Graveyard and $Graveyard.get_rect().has_point($Graveyard.to_local(get_global_mouse_position())):
		card.reparent_card($CanvasSidebarR/ScrollContainer/Graveyard)
		update_graveyard_drop_location_texture()
	else:
		card.get_parent().remove_child(card)
		original_parent.add_child(card)
		card.is_dragging = false
