extends Control

const FILE_FORMAT = ".cfg"
const MAX_SAVE_FILES = 3

const SAVE_PATH = "res://saves/"
const SAVE_ICON_BUTTON = preload("res://UI/Saving/SaveIconButton.tscn")

var current_toggled_save_slot = null
@onready var save_list = $PanelContainer/MarginContainer/VBoxContainer/SaveList

func _ready():
	load_existing_save_slots()

func save_game():
	var save_name = generate_save_name()
	var save_data = serialize_game_state()
	if list_save_files().size() < MAX_SAVE_FILES:
		save_to_file(save_name, save_data)
		create_save_slot(save_name)

func generate_save_name() -> String:
	var dateTime = Time.get_datetime_string_from_system()
	return "Save_" + dateTime + FILE_FORMAT

func serialize_game_state() -> Dictionary:
	var game_state = {
		"player_position": get_player_position(),
		"player_health": get_player_health(),

	}
	return game_state

func save_to_file(save_name, save_data):
	var file = FileAccess.open(SAVE_PATH + save_name, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	file.close()

func load_existing_save_slots():
	var save_files = list_save_files()
	for save_name in save_files:
		create_save_slot(save_name)

func list_save_files() -> Array:
	var dir = DirAccess.open(SAVE_PATH)
	var save_files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(FILE_FORMAT):
				save_files.append(file_name)
				print(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return save_files

func create_save_slot(save_name):
	var save_slot = SAVE_ICON_BUTTON.instantiate()
	save_slot.save_label = save_name
	save_slot.connect("button_toggled", Callable(self, "select_save_slot"))
	save_list.add_child(save_slot)
	update_save_slot(save_name, save_slot)

func update_save_slot(save_name, save_slot):
	var file = FileAccess.open(SAVE_PATH + save_name, FileAccess.READ)
	var path = SAVE_PATH + save_name
	if file.file_exists(path):
		var save_data = JSON.stringify(file.get_as_text())
		file.close()
		var save_label = save_slot.find_child("SaveLabel")
		var date_label = save_slot.find_child("DateLabel")
		var dateTime = Time.get_datetime_string_from_system()
		save_label.text = save_name
		date_label.text = "Date: " + dateTime

func select_save_slot(save_slot):
	if current_toggled_save_slot and current_toggled_save_slot != save_slot:
		current_toggled_save_slot.set_pressed(false)
	current_toggled_save_slot = save_slot

	print(current_toggled_save_slot)
	return current_toggled_save_slot


func _on_load_button_pressed():
	if current_toggled_save_slot:
		load_save_slot(current_toggled_save_slot)
	else:
		print("No save slot is currently selected.")

func load_save_slot(save_slot):
	var save_name = save_slot.save_label.text
	var file = FileAccess.file_exists(SAVE_PATH + save_name)
	print(SAVE_PATH + save_slot.save_label.text)
	print(file)
	if not file:
		print("Save file does not exist.")
		return
	var save_game = FileAccess.open(SAVE_PATH + save_name, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		print(node_data)


func _on_save_button_pressed():
	save_game()


func get_player_position():
	return Vector3.ZERO

func get_player_health():
	return {"current_health": 100, "max_health": 100}
