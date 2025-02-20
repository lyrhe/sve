extends Button

func _on_pressed() -> void:
	$FileDialog.visible = not $FileDialog.visible
