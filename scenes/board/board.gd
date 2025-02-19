extends Node2D

@export var zones: Array[Zone] = []

func _ready():
	for zone in zones:
		zone.toggle_visibility.connect(_on_zone_toggle)
	
func _on_zone_toggle(zone: Zone):
	for board_zone in zones:
		board_zone.toggle_cards_list(zone == board_zone)
	
