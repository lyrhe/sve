extends Control

@onready var dialog = self.get_parent()

var user_input = ""

func _ready():
	dialog.get_ok_button().text = "OK"
	dialog.connect("confirmed", _on_dialog_confirmed)

func show_input_dialog():
	self.text = ""  # Clear previous input
	dialog.popup_centered()

func _on_dialog_confirmed():
	user_input = self.text
	
