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

func check_position(card, original_parent):
	if is_dropped_in_zone($CanvasExArea/ExArea):
		if $CanvasExArea/ExArea.get_child_count() < 5:
			card.reparent_card($CanvasExArea/ExArea, card.evolved)
		elif $CanvasExArea/ExArea.get_child_count() >= 5:
			card.get_parent().remove_child(card)
			original_parent.add_child(card)
			card.is_dragging = false
	elif is_dropped_in_zone($CanvasField/Field):
		if $CanvasField/Field.get_child_count() < 5:
			card.reparent_card($CanvasField/Field, card.evolved)
		elif $CanvasField/Field.get_child_count() >= 5:
			card.get_parent().remove_child(card)
			original_parent.add_child(card)
			card.is_dragging = false
	elif is_dropped_in_zone($CanvasPlayerHand/PlayerHand):
		if card.token == "yes":
			card.get_parent().remove_child(card)
			return
		card.reparent_card($CanvasPlayerHand/PlayerHand, card.evolved)
	elif is_dropped_in_zone($Graveyard):
		card.reparent_card($CanvasSidebarR/ScrollContainer/Graveyard, card.evolved)
		update_graveyard_drop_location_texture()
	elif is_dropped_in_zone($EvolveDeck):
		if card.evolved == "yes":
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
	var lines2 = []
	for n in lines:
		var x = n.strip_edges()
		lines2.append(x)
	for n in lines2 :
		var card_instance = card.instantiate()
		var texture_path = "res://Assets/tokens/" + n + ".png"
		var card_texture = load(texture_path)
		card_instance.texture = card_texture
		card_instance.card_code = n
		tokens_drawer.add_child(card_instance, true)
		card_instance.token = "yes"

func _on_tokens_pressed() -> void:
	print($CanvasSidebarR/ScrollContainer/TokensDrawer.visible)
	$CanvasSidebarR/ScrollContainer/TokensDrawer.visible = not $CanvasSidebarR/ScrollContainer/TokensDrawer.visible
	
func is_dropped_in_zone(zone: Node):
	return zone and zone.get_rect().has_point(get_global_mouse_position())
