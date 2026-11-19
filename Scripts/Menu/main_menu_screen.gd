extends MenuScreen

@onready var menu : Menu = $".."

func _on_player_vs_player_button_pressed() -> void:
	_start_game(GameConfig.GameMode.PLAYER_VS_PLAYER)


func _on_player_vsai_button_pressed() -> void:
	_start_game(GameConfig.GameMode.PLAYER_VS_AI)


func _on_multiplayer_button_pressed() -> void:
	menu.set_screen($"../MultiplayerSetupScreen")

func _start_game(game_mode : GameConfig.GameMode):
	GameConfig.game_mode = game_mode
	SceneManager.load_game()
