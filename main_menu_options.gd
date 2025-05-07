extends VBoxContainer

@onready var http_request := HTTPRequest.new()
var card_index := 1
var SET_CODE := "BP09"
const BASE_URL := "https://en.shadowverse-evolve.com/wordpress/wp-content/images/cardlist"
const IMAGE_FOLDER := "user://cards/"

func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	pivot_offset = size / 2

func _on_lobby_pressed() -> void:
	pass

func _on_deckbuilder_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test/test.tscn")

func _on_update_database_pressed() -> void:
	card_index = 1
	download_next_card()

func _on_quit_pressed() -> void:
	get_tree().quit()

func download_next_card():
	if card_index > 200:
		print("Download complete.")
		return

	var card_number := ""
	if card_index < 10:
		card_number = "00%d" % card_index
	elif card_index < 100:
		card_number = "0%d" % card_index
	else:
		card_number = "%d" % card_index

	var filename = "%s-%sEN.png" % [SET_CODE, card_number]
	var url = "%s/%s/%s" % [BASE_URL, SET_CODE, filename]
	http_request.request(url)
	print("Requesting: ", url)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var card_number = card_index
		if card_number < 10:
			card_number = "00%d" % card_index
		elif card_index < 100:
			card_number = "0%d" % card_index
		else:
			card_number = "%d" % card_index
		var filename = "%s-%sEN.png" % [SET_CODE, card_number]

		var dir = DirAccess.open("user://")
		if not dir.dir_exists("cards"):
			dir.make_dir("cards")

		var file_path = IMAGE_FOLDER + filename
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		if file:
			file.store_buffer(body)
			file.close()
			print("Saved: ", file_path)
		else:
			print("Failed to open file: ", file_path)
	else:
		pass

	card_index += 1
	download_next_card()
