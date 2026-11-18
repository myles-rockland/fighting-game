extends MenuScreen

@onready var username_input : LineEdit = $VBoxContainer/UsernameInput
@onready var ip_input : LineEdit = $VBoxContainer/IPInput
@onready var port_input : LineEdit = $VBoxContainer/PortInput

@onready var menu : Menu = $".."


func _on_back_button_pressed() -> void:
	menu.set_screen($"../MainMenuScreen")

func _on_create_game_button_pressed() -> void:
	print("Create server")

func _on_join_game_button_pressed() -> void:
	print("Join server")
