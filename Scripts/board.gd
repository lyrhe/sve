class_name Board
extends Node2D

const card = preload("res://Scenes/card.tscn")
@export var tokens_drawer : GridContainer

func _ready():
	token_drawer_populate()

# Ouvre le menu pour charger un deck - @LoadDeckButton
func _on_menu_button_pressed() -> void:
	$LoadDeckButton/FileDialog.popup_centered()

func update_graveyard_drop_location_texture():
	var last_child = ""
	if not $CanvasSidebarR/ScrollContainer/Graveyard:
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

func check_position(card: Card, original_parent: Node):
	if is_dropped_in_zone($CanvasExArea/ExArea):
		move_into_zone(original_parent, $CanvasExArea/ExArea, card)
	elif is_dropped_in_zone($CanvasField/Field):
		move_into_zone(original_parent, $CanvasField/Field, card)
	elif is_dropped_in_zone($CanvasPlayerHand/PlayerHand):
		if card.token:
			card.get_parent().remove_child(card)
			return
		card.reparent_card($CanvasPlayerHand/PlayerHand, card.evolved)
	elif is_dropped_in_area2D($Graveyard):
		card.reparent_card($CanvasSidebarR/ScrollContainer/Graveyard, card.evolved)
		update_graveyard_drop_location_texture()
	elif is_dropped_in_area2D($EvolveDeck):
		if card.evolved:
			card.reparent_card($CanvasSidebarL/ScrollContainer/EvolveDeck, card.evolved)
		else:
			card.get_parent().remove_child(card)
			original_parent.add_child(card)
			card.is_dragging = false
	else:
		card.get_parent().remove_child(card)
		original_parent.add_child(card)
		card.is_dragging = false

func token_drawer_populate():
	var deck_file_path = "res://Assets/tokens/tokens.txt"
	var file = FileAccess.open(deck_file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open deck file: " + deck_file_path)
		return

	var lines := file.get_as_text().split("\r", false)
	for n in lines:
		var card_instance = card.instantiate()
		var card_name = n.strip_edges()
		var card_texture = load("res://Assets/tokens/" + card_name + ".png")
		card_instance.texture = card_texture
		card_instance.card_code = n
		tokens_drawer.add_child(card_instance, true)
		card_instance.token = true

func _on_tokens_pressed() -> void:
	$CanvasSidebarR/ScrollContainer/TokensDrawer.visible = not $CanvasSidebarR/ScrollContainer/TokensDrawer.visible
	
func is_dropped_in_zone(zone: Node):
	return zone != null and zone.get_rect().has_point(get_global_mouse_position())
	
func is_dropped_in_area2D(zone: Node):
	return zone != null and zone.get_rect().has_point(zone.to_local(get_global_mouse_position()))

func move_into_zone(old_zone: Node, new_zone: Node, card: Card):
	if new_zone.get_child_count() < 5:
		card.reparent_card(new_zone, card.evolved)
	else:
		card.get_parent().remove_child(card)
		old_zone.add_child(card)
		card.is_dragging = false
