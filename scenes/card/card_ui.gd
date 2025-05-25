class_name CardUi extends Control

const CARDS_GRAPHICS_PATH = "user://cards"

signal reparent_requested(which_card_ui: CardUi)
signal update_texture()
signal is_changing_zone(card_ui: CardUi)
signal on_spawn_menu(card_ui: CardUi)
signal move_to_deck(card_ui: CardUi)
signal switch_rarity(card_ui: CardUi)

@export var metadata: Card
@onready var texture_rect: TextureRect = $TextureRect
@onready var _zone_detector: Area2D = $ZoneDetector
@onready var state_machine: CardStateMachine = $CardStateMachine
@onready var previous_parent: Container = self.get_parent() if self.get_parent() is Container else null
@onready var atk: Label = $atk_def/atk
@onready var def: Label = $atk_def/def
@onready var atk_def: TextureRect = $atk_def
@onready var counters: Label = $counters
@onready var bigger_frame: CanvasLayer
@onready var collision_shape: CollisionShape2D = $CardCollision/CollisionShape2D

# ajouts evolve
@onready var deserializer = DeckDeserializer.new()
var evolve_deck = null
var field = null

var targets: Array[Zone] = []

func _ready() -> void:
	state_machine.init(self)
	var path = CARDS_GRAPHICS_PATH + "/" + self.metadata.card_id + ".png"
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
	#if not self.metadata.type == "Follower":
		#$atk_def.visible = false
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

var _mouse_inside = false

func _on_mouse_entered():
	_mouse_inside = true

	if Input.is_key_pressed(KEY_CTRL):
		return

	bigger_frame.visible = true
	bigger_frame.get_child(0).texture = texture_rect.texture

	var card_name = self.metadata.card_name
	var card_traits: Array = self.metadata.card_traits
	var card_effect: String = self.metadata.card_effect
	var is_evolved: bool = self.metadata.evolved

	# Convert each trait to a BBCode [url]
	var clickable_traits := []
	for x in card_traits:
		clickable_traits.append("[url=%s]%s[/url]" % [x, x])
	var trait_text = " / ".join(clickable_traits)

	# Add "Evolved" if applicable
	if is_evolved:
		trait_text += " - Evolved"

	# Convert [something] in card_effect to [url=something]something[/url]
	var clickable_keywords := ["Fanfare", "Quick", "On Evolve", "Ward", "last Words", "Strike", "Storm", "Rush", "Assail", "Intimidate", "Feed", "Drain", "Bane", "Aura", "Combo", "Spellchain", "Stack", "Earth Rite", "Overflow", "Necrocharge", "Sanguine", "Lesson", "Race", "Act", "Engage", "[Evolve"]
	for keyword in clickable_keywords:
		card_effect = card_effect.replace(
			keyword,
			"[url=%s]%s[/url]" % [keyword, keyword]
		)

	var info_text = "%s - %s\n------\n%s" % [card_name, trait_text, card_effect]
	var related_cards: Array = self.metadata.related_cards
	if not related_cards.is_empty():
		info_text += "\n\nRelated card:\n"
		for rel_id in related_cards:
			info_text += "[url=%s]%s[/url] " % [rel_id, rel_id]
		
	var label = bigger_frame.get_child(2)
	label.bbcode_enabled = true
	label.text = info_text
	state_machine.on_mouse_entered()
	label.connect("meta_hover_started", Callable(self, "_on_related_hover_start"))
	label.connect("meta_hover_ended", Callable(self, "_on_related_hover_end"))

var related_preview: TextureRect = null

func _on_related_hover_start(meta: Variant) -> void:
	if typeof(meta) == TYPE_STRING and "-" in meta:
		var card_id = meta
		var image_path = "user://cards/%s.png" % card_id

		var image := Image.new()
		var err := image.load(image_path)
		if err != OK:
			print("Failed to load image:", image_path)
			return

		var texture := ImageTexture.create_from_image(image)

		related_preview = TextureRect.new()
		related_preview.texture = texture
		related_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		related_preview.custom_minimum_size = Vector2(60, 90)
		related_preview.scale = Vector2(0.5, 0.5)
		related_preview.position = get_viewport().get_mouse_position() + Vector2(16, 16)
		related_preview.z_index = 999999
		related_preview.z_as_relative = false
		var preview_frame = bigger_frame.get_node("PreviewFrame")  # Adjust path if needed
		preview_frame.add_child(related_preview)

func _on_related_hover_end(meta: Variant) -> void:
	if related_preview and related_preview.is_inside_tree():
		related_preview.queue_free()
		related_preview = null

func _on_mouse_exited():
	_mouse_inside = false
	if not Input.is_key_pressed(KEY_CTRL):
		bigger_frame.visible = false
		state_machine.on_mouse_exited()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_CTRL and not event.pressed:
		if not _mouse_inside:
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
		#on_spawn_menu.emit(self)
		switch_rarity.emit(self)
	if event is InputEventMouseButton and Input.is_action_just_pressed("right_mouse_click"):
		move_to_deck.emit(self)

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
