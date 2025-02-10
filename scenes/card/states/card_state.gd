class_name CardState extends Node

enum State {
	BASE_STAND,
	BASE_REST,
	CLICKED,
	DRAGGING,
	RELEASED
}

signal transition_requested(from: CardState, to: State)

@export var state: State

var card_ui: CardUi

func enter():
	pass
	
func exit():
	pass
	
func on_input(event: InputEvent):
	pass
	
func on_gui_input(event: InputEvent):
	pass
	
func on_mouse_entered():
	pass
	
func on_mouse_exited():
	pass
