extends HBoxContainer

@export var grid_container : Control
@export var type_filter : OptionButton
@export var class_filter : OptionButton
@export var universe_filter : OptionButton
@export var rarity_filter : OptionButton
@export var evolved_filter : OptionButton
@export var name_filter : LineEdit
@export var trait_filter : LineEdit
@export var cost_filter : SpinBox

var selected_type: String = "All"
var selected_class: String = "All"
var selected_universe: String = "All"
var selected_rarity: String = "All"
var selected_evolved: String = "All"
var name_query: String = ""
var trait_query: String = ""
var seletected_cost: String = ""

func _ready():
	type_filter.item_selected.connect(_on_filter_changed)
	class_filter.item_selected.connect(_on_filter_changed)
	universe_filter.item_selected.connect(_on_filter_changed)
	rarity_filter.item_selected.connect(_on_filter_changed)
	evolved_filter.item_selected.connect(_on_filter_changed)
	name_filter.text_changed.connect(_on_text_filter_changed)
	trait_filter.text_changed.connect(_on_text_filter_changed)
	_apply_filters()

func _on_filter_changed(_index: int):
	selected_type = type_filter.get_item_text(type_filter.get_selected_id())
	selected_class = class_filter.get_item_text(class_filter.get_selected_id())
	selected_universe = universe_filter.get_item_text(universe_filter.get_selected_id())
	selected_rarity = rarity_filter.get_item_text(rarity_filter.get_selected_id())
	selected_evolved = evolved_filter.get_item_text(evolved_filter.get_selected_id())
	_apply_filters()
	
func _on_text_filter_changed(new_text: String):
	trait_query = trait_filter.text.to_lower().strip_edges()
	name_query = name_filter.text.to_lower().strip_edges()
	_apply_filters()
	

func _apply_filters():
	for child in grid_container.cards_container.get_children():
		var matches_type = (selected_type == "All" or child.metadata.type == selected_type)
		var matches_class = (selected_class == "All" or child.metadata.card_class == selected_class)
		var matches_universe = (selected_universe == "All" or child.metadata.universe == selected_universe)
		var matches_rarity = (selected_rarity == "All" or child.metadata.rarity == selected_rarity)
		var matches_evolved = (selected_evolved == "All" or (selected_evolved == "true" and child.metadata.evolved) or (selected_evolved == "false" and not child.metadata.evolved))
		var matches_name = (name_query.is_empty() or child.metadata.card_name.to_lower().contains(name_query))
		var matches_trait = (trait_query.is_empty() or child.metadata.card_trait.to_lower().contains(trait_query))
		child.visible = matches_type and matches_class and matches_universe and matches_rarity and matches_trait and matches_name and matches_evolved
