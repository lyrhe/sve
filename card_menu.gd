extends Node2D

func popup():
	$PopupMenu.popup(Rect2i(get_global_mouse_position().x, get_global_mouse_position().y, $PopupMenu.size.x, $PopupMenu.size.y))
