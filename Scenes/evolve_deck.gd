extends Sprite2D

@export var evolve_deck_grid : GridContainer
const card = preload("res://Scenes/card.tscn")

func _ready() -> void:
	load_evolve_deck("res://Test/evolve_deck_MONO.txt")

func load_evolve_deck(deck_file_path: String) -> void:
	for n in evolve_deck_grid.get_children():
		evolve_deck_grid.remove_child(n)
		n.queue_free()
	var file = FileAccess.open(deck_file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open deck file: " + deck_file_path)
		return
	var lines := file.get_as_text().split("\n", false)
	var cards := []
	for n in lines :
		var card_instance = card.instantiate()
		var texture_path = "res://Assets/card_images/%s.png" % n
		var card_texture = load(texture_path)
		card_instance.evolved = true
		card_instance.texture = card_texture
		card_instance.card_code = n
		evolve_deck_grid.add_child(card_instance, true)
	for n in range(evolve_deck_grid.get_child_count()):
		evolve_deck_grid.get_child(n).evolved = true

func _on_evolve_deck_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("right_mouse_click"):
		evolve_deck_grid.visible = not evolve_deck_grid.visible
