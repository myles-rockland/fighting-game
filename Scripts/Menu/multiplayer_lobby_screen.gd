extends MenuScreen

@onready var menu : Menu = $".."

@onready var player_host_name : Label = $PlayerHost
@onready var player_client_name : Label = $PlayerClient

@onready var start_game_button : Button = $StartGameButton

func open():
	_update_ui()

func _update_ui():
	pass

func _on_leave_button_pressed() -> void:
	# TODO: Disconnect from the server
	menu.set_screen($"../MainMenuScreen")

func _on_start_game_button_pressed() -> void:
	print("Start game")
