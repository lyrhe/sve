class_name CardUi extends Control

const CARDS_GRAPHICS_PATH = "res://assets/cards"

signal reparent_requested(which_card_ui: CardUi)
signal update_texture()

@export var metadata: Card
@onready var texture_rect: TextureRect = $TextureRect
@onready var _zone_detector: Area2D = $ZoneDetector
@onready var state_machine: CardStateMachine = $CardStateMachine
@onready var previous_parent: Container = self.get_parent()
@onready var atk: Label = $atk_def/atk
@onready var def: Label = $atk_def/def

var targets: Array[Zone] = []

func _ready() -> void:
	state_machine.init(self)
	texture_rect.texture = load(CARDS_GRAPHICS_PATH + "/" + self.metadata.card_id + ".png")
	if not self.metadata.used or self.get_parent() is HBoxContainer:
		texture_rect.set_material(null)
	if not self.metadata.type == "Follower":
		$atk_def.visible = false
	self.atk.text = str(self.metadata.attack)
	self.def.text = str(self.metadata.defense)

#region Input events
func _input(event: InputEvent) -> void:
	state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	state_machine.on_gui_input(event)
#endregion

#region Mouse events
func _on_mouse_entered():
	get_tree().root.get_child(0).get_child(0).visible = true
	get_tree().root.get_child(0).get_child(0).get_child(0).texture = texture_rect.texture
	state_machine.on_mouse_entered()

func _on_mouse_exited():
	get_tree().root.get_child(0).get_child(0).visible = false
	state_machine.on_mouse_exited()
#endregion

#region Drop zone events
func _on_zone_entered(area2d: Area2D) -> void:
	if not targets.has(area2d.get_parent()):
		targets.append(area2d.get_parent() as Zone)

func _on_zone_exited(area2d: Area2D) -> void:
	targets.erase(area2d.get_parent())
#endregion
