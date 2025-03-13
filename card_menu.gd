class_name CardMenu extends Node2D

var current_card_ui: CardUi = null

func _ready():
	$PopupMenu.id_pressed.connect(_on_menu_item_selected)

func popup(card_ui: CardUi):
	current_card_ui = card_ui
	$PopupMenu.popup(Rect2i(get_global_mouse_position().x, get_global_mouse_position().y, $PopupMenu.size.x, $PopupMenu.size.y))

func _on_menu_item_selected(id: int):
	if current_card_ui == null:
		return
	if id == 0:
		current_card_ui.evolve()
	current_card_ui = null
