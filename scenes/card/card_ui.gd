class_name CardUi extends Control

const CARDS_GRAPHICS_PATH = "user://cards"

signal reparent_requested(which_card_ui: CardUi)
signal update_texture()
signal is_changing_zone(card_ui: CardUi)
signal on_spawn_menu(card_ui: CardUi)

@export var metadata: Card
@onready var texture_rect: TextureRect = $TextureRect
@onready var _zone_detector: Area2D = $ZoneDetector
@onready var state_machine: CardStateMachine = $CardStateMachine
@onready var previous_parent: Container = self.get_parent() if self.get_parent() is Container else null
@onready var atk: Label = $atk_def/atk
@onready var def: Label = $atk_def/def
@onready var counters: Label = $counters
@onready var bigger_frame: CanvasLayer

# ajouts evolve
@onready var deserializer = DeckDeserializer.new()
var evolve_deck = null
var field = null

var targets: Array[Zone] = []

func _ready() -> void:
	state_machine.init(self)
	var path = CARDS_GRAPHICS_PATH + "/" + self.metadata.card_id + "EN.png"
	if not FileAccess.file_exists(path):
		push_warning("Image not found: " + path)
		return
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		push_error("Failed to load image. Error: " + str(err))
		return
	var texture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture
	if not self.metadata.used or self.get_parent() is HBoxContainer:
		texture_rect.set_material(null)
	if not self.metadata.type == "Follower":
		$atk_def.visible = false
	atk.text = str(self.metadata.attack)
	def.text = str(self.metadata.defense)

func update_atk_def():
	print(self.metadata.attack)
	self.atk.text = str(self.metadata.attack)
	print(self.metadata.defense)
	self.def.text = str(self.metadata.defense)
	
func update_shader():
	if self.metadata.used:
		texture_rect.set_material(load("res://scenes/card/CardUiVisualShader.tres"))
	else:
		texture_rect.set_material(null)
	
func reparent_to_previous_parent(node):
	var clone = node.duplicate()
	node.previous_parent.add_child(clone)
	node.queue_free()

#region Input events
func _input(event: InputEvent) -> void:
	state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	state_machine.on_gui_input(event)
#endregion

#region Mouse events
func _on_mouse_entered():
	bigger_frame.visible = true
	bigger_frame.get_child(0).texture = texture_rect.texture
	var card_name = self.metadata.card_name
	var card_effect = "Salut, ça va ? On récupère pas encore les effets des cartes."
	bigger_frame.get_child(2).text = "%s\n------\n%s" % [card_name, card_effect]
	state_machine.on_mouse_entered()

func _on_mouse_exited():
	bigger_frame.visible = false
	state_machine.on_mouse_exited()
#endregion

func add_counter():
	pass
	
#region Drop zone events
func _on_zone_entered(area2d: Area2D) -> void:
	if not targets.has(area2d.get_parent()):
		targets.append(area2d.get_parent() as Zone)

func _on_zone_exited(area2d: Area2D) -> void:
	targets.erase(area2d.get_parent())
#endregion

func _on_card_collision_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("wheel_click"):
		on_spawn_menu.emit(self)
		
func evolve():
	var evolve_code = (deserializer.get_evolve(self.metadata.card_id))
	print(self.get_index())
	var index = self.get_index()
	if self.metadata.type == "Follower":
		for child in evolve_deck.get_children():
			if child.metadata.card_id == evolve_code and not child.metadata.used:
				child.reparent(field)
				field.move_child(child, index)
				self.queue_free()
				return
