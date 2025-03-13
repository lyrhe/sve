class_name Board extends Node2D

# Récupère la liste des piles du jeu.
@export var zones: Array[Zone] = []

# Connecte le signal toggle_visibility de chaque zone à _on_zone_toggle.
func _ready():
	for zone in zones:
		zone.toggle_visibility.connect(_on_zone_toggle)

# Passe "true" pour la zone qui a émis le signal et false pour les autres,
# affichant donc la première et fermant toutes les autres.
func _on_zone_toggle(zone: Zone):
	for board_zone in zones:
		board_zone.toggle_cards_list(zone == board_zone)

func _on_spawn_menu(card_ui: CardUi):
	$CardMenu.popup(card_ui)
	
	
