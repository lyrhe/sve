extends HBoxContainer

# Container + Filtres
@export var grid_container : Control
@export var type_filter : OptionButton
@export var class_filter : OptionButton
@export var universe_filter : OptionButton
@export var rarity_filter : OptionButton
@export var evolved_filter : OptionButton
@export var set_filter : OptionButton
@export var name_filter : LineEdit
@export var trait_filter : LineEdit
@export var cost_filter : SpinBox
@export var sort_filter : OptionButton
@export var effect_filter : LineEdit
@onready var filters = []

# Option de base pour chaque filtre
var selected_type: String = "All Types"
var selected_class: String = "All Classes"
var selected_universe: String = "All Universes"
var selected_rarity: String = "All Rarities"
var selected_evolved: String = "All Evo/Base"
var selected_set: String = "All Sets"
var name_query: String = ""
var trait_query: String = ""
var effect_query: String = ""
var selected_cost: float = -1
var selected_sort: String = "Sets"

# Connect each signal to filter_change/text_change
func _ready():
	type_filter.item_selected.connect(_on_filter_changed.bind(type_filter))
	class_filter.item_selected.connect(_on_filter_changed.bind(class_filter))
	universe_filter.item_selected.connect(_on_filter_changed.bind(universe_filter))
	rarity_filter.item_selected.connect(_on_filter_changed.bind(rarity_filter))
	evolved_filter.item_selected.connect(_on_filter_changed.bind(evolved_filter))
	set_filter.item_selected.connect(_on_filter_changed.bind(set_filter))
	
	name_filter.text_changed.connect(_on_text_filter_changed)
	trait_filter.text_changed.connect(_on_text_filter_changed)
	cost_filter.value_changed.connect(_on_filter_changed.bind(null))
	sort_filter.item_selected.connect(_on_sort_changed)
	effect_filter.text_changed.connect(_on_text_filter_changed)

	for child in self.get_children():
		if child is OptionButton:
			filters.append(child)
		
	_apply_filters()


# Change selected_x based on filter option
func _on_filter_changed(_index: int, filter: OptionButton = null):
	selected_type = type_filter.get_item_text(type_filter.get_selected_id())
	selected_class = class_filter.get_item_text(class_filter.get_selected_id())
	selected_universe = universe_filter.get_item_text(universe_filter.get_selected_id())
	selected_rarity = rarity_filter.get_item_text(rarity_filter.get_selected_id())
	selected_evolved = evolved_filter.get_item_text(evolved_filter.get_selected_id())
	selected_set = set_filter.get_item_text(set_filter.get_selected_id())
	selected_cost = cost_filter.value
	
	if filter != null:
		_update_filter_theme(filter)

	_apply_filters()


# Change query based on filter option
func _on_text_filter_changed(new_text: String):
	trait_query = trait_filter.text.to_lower().strip_edges()
	name_query = name_filter.text.to_lower().strip_edges()
	effect_query = effect_filter.text
	_apply_filters()

# 
func _on_sort_changed(_index: int = 0):
	#selected_sort = sort_filter.get_item_text(sort_filter.get_selected_id())
	_apply_sorting()

# 
func _apply_filters():
	for child in grid_container.cards_container.get_children():
		var matches_type = (selected_type == "All Types" or child.metadata.type == selected_type)
		var matches_class = (selected_class == "All Classes" or child.metadata.card_class == selected_class)
		var matches_universe = (selected_universe == "All Universes" or child.metadata.universe == selected_universe)
		var matches_rarity = (selected_rarity == "All Rarities" or child.metadata.rarity == selected_rarity)
		var matches_evolved = (selected_evolved == "All Evo/Base" or (selected_evolved == "Evolved" and child.metadata.evolved) or (selected_evolved == "Base" and not child.metadata.evolved))
		var matches_name = (name_query.is_empty() or child.metadata.card_name.to_lower().contains(name_query))
		var matches_trait = trait_query.is_empty()
		if not matches_trait:
			for x in child.metadata.card_traits:
				if x.to_lower().contains(trait_query):
					matches_trait = true
					break
		var matches_set = (selected_set == "All Sets" or child.metadata.card_set == selected_set)
		var matches_cost = (selected_cost == -1 or child.metadata.cost == selected_cost)
		var matches_effect = (effect_query.is_empty() or child.metadata.card_effect.contains(effect_query))
		child.visible = matches_type and matches_class and matches_universe and matches_rarity and matches_trait and matches_name and matches_evolved and matches_set and matches_cost and matches_effect

#
func _apply_sorting():
	var children = grid_container.cards_container.get_children()
	var sort_mode = $Sort.get_selected_id() 
	match sort_mode:
		0:  # Release Date (ascending)
			children.sort_custom(func(a, b):
				var a_date = parse_date(a.metadata.release_date)
				var b_date = parse_date(b.metadata.release_date)
				return a_date < b_date or (a_date == b_date and a.metadata.card_id < b.metadata.card_id)
			)
		1:  # ascending -> name
			children.sort_custom(func(a, b):
				return a.metadata.cost < b.metadata.cost or (
			a.metadata.cost == b.metadata.cost and a.metadata.card_name < b.metadata.card_name
		)
	)
		2:  # descending -> name
			children.sort_custom(func(a, b):
				return a.metadata.cost > b.metadata.cost or (
			a.metadata.cost == b.metadata.cost and a.metadata.card_name < b.metadata.card_name
		)
	)
		3:  # a-z
			children.sort_custom(func(a, b): return a.metadata.card_name < b.metadata.card_name)
		4:  # z-a
			children.sort_custom(func(a, b): return a.metadata.card_name > b.metadata.card_name)
		5: # atk (asc)
			children.sort_custom(func(a, b): return a.metadata.attack < b.metadata.attack)
		6: # def (asc)
			children.sort_custom(func(a, b): return a.metadata.defense < b.metadata.defense)

	for child in children:
		grid_container.cards_container.move_child(child, grid_container.cards_container.get_child_count())


func _on_reset_filters_pressed() -> void:
	selected_type = "All Types"
	selected_class = "All Classes"
	selected_universe = "All Universes"
	selected_rarity = "All Rarities"
	selected_evolved = "All Evo/Base"
	selected_set = "All Sets"
	name_query = ""
	trait_query = ""
	effect_query = ""
	selected_cost = -1
	selected_sort = "Sets"
	
	type_filter.selected = 0
	class_filter.selected = 0
	universe_filter.selected = 0
	rarity_filter.selected = 0
	evolved_filter.selected = 0
	set_filter.selected = 0
	name_filter.text = ""
	trait_filter.text = ""
	cost_filter.value = -1
	effect_filter.text = ""
	sort_filter.selected = 0
	_apply_filters()
	_apply_sorting()
	for filter in filters:
		_update_filter_theme(filter)

func _update_filter_theme(filter: OptionButton) -> void:
	if filter.selected > 0:
		filter.theme = load("res://themes/filter_selected.tres")
	else:
		filter.theme = load("res://themes/filter_base.tres")
	

func parse_date(date_string: String) -> int:
	# Assumes ISO format: "YYYY-MM-DD"
	var parts = date_string.split("-")
	if parts.size() != 3:
		return 0  # fallback
	var year = int(parts[0])
	var month = int(parts[1])
	var day = int(parts[2])
	return year * 10000 + month * 100 + day  # YYYYMMDD for numeric comparison


#func _on_type_item_selected(index: int) -> void:
	#if index > 0:
		#type_filter.theme = load("res://filter_selected.tres")
	#else:
		#type_filter.theme = load("res://filter_base.tres")
	#
