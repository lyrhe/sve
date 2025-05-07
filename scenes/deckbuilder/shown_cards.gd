extends Label

func _on_visible_card_count_changed(count: int) -> void:
	self.text = "Visible Cards: %d" % count
