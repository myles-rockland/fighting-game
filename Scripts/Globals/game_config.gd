extends Node

enum GameMode
{
	PLAYER_VS_PLAYER,
	PLAYER_VS_AI,
	ONLINE_MULTIPLAYER,
}

var game_mode : GameMode = GameMode.PLAYER_VS_AI
