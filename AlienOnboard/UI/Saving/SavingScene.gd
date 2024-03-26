extends Control


@onready var action_list = $PanelContainer/MarginContainer/ActionList

const MAX_SAVE_SLOTS = 3
var save_list = {
}

func _ready():
	save_game()

func save():
	var Save_Dictionary = {
		"Health": 3,
		"Defence": 3,
		"XP": 1,
		"EP": 1,
		"PlayerRot": Vector3(0,0,0),
		"PlayerPos" : Vector3(0,0,0)
	}
	
	return Save_Dictionary
	
func save_game():
	var save_game = FileAccess.open_encrypted_with_pass("res://AlienOnBoard.json", FileAccess.WRITE, "SaveEncryption")
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)
	
func load_game():
	if not FileAccess.file_exists("res://AlienOnBoard.json"):
		return
	
	var save_game = FileAccess.open_encrypted_with_pass("res://AlienOnBoard.json", FileAccess.READ, "SaveEncryption")
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_results = json.parse(json_string)

		var node_data = json.get_data()
		
		print(node_data)
	



func _on_save_button_pressed():
	save_game()
	


func _on_load_button_pressed():
	load_game()
