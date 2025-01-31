extends Sprite2D

@export var board : Node
@export var player_hand : HBoxContainer
@export var azecazecaze : GridContainer
var graveyard : Array[String] = []
const CARD_SCENE_PATH = "res://Scenes/card.tscn"

func update_graveyard_texture() -> void:
	pass

func _on_graveyard_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('right_mouse_click'):
			print("mdr")
			if azecazecaze.visible == false:
				azecazecaze.visible = true
			elif azecazecaze.visible == true:
				azecazecaze.visible = false
