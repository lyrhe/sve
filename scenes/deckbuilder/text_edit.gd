extends RichTextLabel

@export var filters: HBoxContainer
@export var trait_filter : LineEdit
@export var effect_filter: LineEdit

var effect_keywords := [
	"Fanfare", "Quick", "On Evolve", "Ward", "Last Words", "Strike",
	"Storm", "Rush", "Assail", "Intimidate", "Feed", "Drain",
	"Bane", "Aura", "Combo", "Spellchain", "Stack", "Earth Rite",
	"Overflow", "Necrocharge", "Sanguine", "Lesson", "Race",
	"Act", "Engage", "[Evolve"
]

func _on_meta_clicked(meta: Variant) -> void:
	var keyword = meta.strip_edges()
	if keyword in effect_keywords:
		effect_filter.text = meta
		filters.effect_query = keyword
	elif not "-" in keyword:
		trait_filter.text = meta
		filters.trait_query = keyword.to_lower().strip_edges()
	filters._apply_filters()
