extends MenuScreen

@onready var menu : Menu = $".."

@onready var player_host_name : Label = $PlayerHost
@onready var player_client_name : Label = $PlayerClient

@onready var start_game_button : Button = $StartGameButton

func _process(delta):
	_update_ui()

func _update_ui():
	if not NetworkManager.is_connected:
		return
	
	start_game_button.visible = NetworkManager.is_server
	
	if NetworkManager.player_host:
		player_host_name.text = NetworkManager.player_host.username
		print("Setting player host name text!!")
	else:
		player_host_name.text = "..."
		
	if NetworkManager.player_client:
		player_client_name.text = NetworkManager.player_client.username
	else:
		player_client_name.text = "..."

func _on_leave_button_pressed() -> void:
	NetworkManager.close_peer()
	menu.set_screen($"../MainMenuScreen")

func _on_start_game_button_pressed() -> void:
	GameConfig.game_mode = GameConfig.GameMode.ONLINE_MULTIPLAYER
	SceneManager.load_game.rpc() # We're not calling the function as we normally would. We're calling it as an RPC, so that other computers do things!
