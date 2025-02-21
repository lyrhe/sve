class_name CardUi extends Control

const CARDS_GRAPHICS_PATH = "res://assets/cards"

signal reparent_requested(which_card_ui: CardUi)

@export var metadata: Card
@export var card_id: String = ""
@onready var texture_rect: TextureRect = $TextureRect
@onready var _zone_detector: Area2D = $ZoneDetector
@onready var state_machine: CardStateMachine = $CardStateMachine
@onready var previous_parent: Container = self.get_parent()

var targets: Array[Zone] = []

func _ready() -> void:
	state_machine.init(self)
	texture_rect.texture = load(CARDS_GRAPHICS_PATH + "/" + self.metadata.card_id + ".png")

#region Input events
func _input(event: InputEvent) -> void:
	state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	state_machine.on_gui_input(event)
#endregion

#region Mouse events
func _on_mouse_entered():
	state_machine.on_mouse_entered()

func _on_mouse_exited():
	state_machine.on_mouse_exited()
#endregion

#region Drop zone events
func _on_zone_entered(area2d: Area2D) -> void:
	if not targets.has(area2d.get_parent()):
		targets.append(area2d.get_parent() as Zone)

func _on_zone_exited(area2d: Area2D) -> void:
	targets.erase(area2d.get_parent())
#endregion
