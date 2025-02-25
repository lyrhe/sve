extends Control

signal option_selected(option: String)

@onready var top_button: Button = $TopButton
@onready var bottom_button: Button = $BottomButton

func _ready():
	hide_options()
	
	top_button.pressed.connect(_on_top_pressed)
	bottom_button.pressed.connect(_on_bottom_pressed)

# Show options when an event occurs
func show_options():
	self.visible = true

# Hide options when selection is made
func hide_options():
	self.visible = false

# Handle top button press
func _on_top_pressed():
	print("Top selected")
	option_selected.emit("top")
	hide_options()

# Handle bottom button press
func _on_bottom_pressed():
	print("Bottom selected")
	option_selected.emit("bottom")
	hide_options()
