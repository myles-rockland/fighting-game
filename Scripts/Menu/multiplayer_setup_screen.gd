extends MenuScreen

@onready var username_input : LineEdit = $VBoxContainer/UsernameInput
@onready var ip_input : LineEdit = $VBoxContainer/IPInput
@onready var port_input : LineEdit = $VBoxContainer/PortInput

@onready var menu : Menu = $".."

var ip : String:
	get: return ip_input.text
var port : int:
	get: return int(port_input.text)

func _on_back_button_pressed() -> void:
	menu.set_screen($"../MainMenuScreen")

func _on_create_game_button_pressed() -> void:
	NetworkManager.local_username = username_input.text
	NetworkManager.start_host(port)

func _on_join_game_button_pressed() -> void:
	NetworkManager.local_username = username_input.text
	NetworkManager.start_client(ip, port)
