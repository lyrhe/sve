extends VBoxContainer

@onready var buttons = $Plus.get_parent().get_children()
@onready var plus_button: TextureButton = $Plus
@onready var minus_button: TextureButton = $Minus

var enabled_count := 0

func _ready():
	for i in range(1, 11):  
		buttons[i].disabled = true
		buttons[i].toggled.connect(_on_button_toggled.bind(i))

	plus_button.pressed.connect(_on_plus_pressed)
	minus_button.pressed.connect(_on_minus_pressed)

func _on_plus_pressed():
	if enabled_count < 11: 
		var index = 11 - enabled_count 
		buttons[index].disabled = false
		enabled_count += 1

func _on_minus_pressed():
	if enabled_count > 0:
		var index = 11 - enabled_count + 1 
		buttons[index].disabled = true
		buttons[index].button_pressed = false
		enabled_count -= 1

func _on_button_toggled(button_pressed: bool, index: int):
	if button_pressed:
		for i in range(index + 1, 11): 
			if buttons[i].disabled: 
				buttons[i].disabled = false
			if not buttons[i].button_pressed: 
				buttons[i].button_pressed = true
	else:
		for i in range(index - 1, 0, -1): 
			if buttons[i].pressed:
				buttons[i].button_pressed = false
