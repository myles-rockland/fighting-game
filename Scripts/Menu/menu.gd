extends Node3D


func _on_player_vs_player_button_pressed() -> void:
	_start_game(GameConfig.GameMode.PLAYER_VS_PLAYER)



func _on_player_vs_ai_button_pressed() -> void:
	_start_game(GameConfig.GameMode.PLAYER_VS_AI)

func _start_game(game_mode : GameConfig.GameMode):
	GameConfig.game_mode = game_mode
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
