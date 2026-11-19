class_name GameManager
extends Node

enum GameState
{
	LOADING,
	COUNTDOWN,
	PLAYING,
	ENDED,
}

@export var player_fighter_scene : PackedScene
@export var ai_fighter_scene : PackedScene

@export var winner_sound : AudioStream
@export var loser_sound : AudioStream

@onready var fighter_0_spawn : Node3D = $Fighter0Spawn
@onready var fighter_1_spawn : Node3D = $Fighter1Spawn

@onready var countdown_animation : AnimationPlayer = $CountdownCanvasLayer/CountdownAnimation
@onready var countdown_timer : Timer = $CountdownTimer

@onready var end_game_text : Label = $CountdownCanvasLayer/EndGameText
@onready var end_game_timer : Timer = $EndGameTimer

var current_game_state : GameState

func _ready():
	GlobalEvents.fighter_defeated.connect(_on_fighter_defeated)
	
	_change_game_state(GameState.LOADING)

func _change_game_state(game_state : GameState):
	current_game_state = game_state
	
	if game_state == GameState.LOADING:
		_setup_fighters()
		
	elif game_state == GameState.COUNTDOWN:
		countdown_animation.play("countdown")
		countdown_timer.start()
		
	elif game_state == GameState.ENDED:
		end_game_timer.start()
		
	GlobalEvents.game_state_changed.emit(current_game_state)

func _on_fighter_defeated(fighter : Fighter):
	_change_game_state(GameState.ENDED)
	
	end_game_text.visible = true
	
	if GameConfig.game_mode == GameConfig.GameMode.PLAYER_VS_PLAYER:
		if fighter.player_id == 0:
			end_game_text.text = "Player 2 Wins"
		else:
			end_game_text.text = "Player 1 Wins"
			
	elif GameConfig.game_mode == GameConfig.GameMode.PLAYER_VS_AI:
		if fighter.player_id == 0:
			end_game_text.text = "LOSER"
			AudioManager.play(loser_sound)
		else:
			end_game_text.text = "WINNER"
			AudioManager.play(winner_sound)

func _setup_fighters():
	var right_fighter_scene : PackedScene
	
	if GameConfig.game_mode == GameConfig.GameMode.PLAYER_VS_PLAYER:
		right_fighter_scene = player_fighter_scene
	elif GameConfig.game_mode == GameConfig.GameMode.PLAYER_VS_AI:
		right_fighter_scene = ai_fighter_scene
		
	var left_fighter : Fighter = _spawn_fighter(player_fighter_scene)
	var right_fighter : Fighter = _spawn_fighter(right_fighter_scene)
	
	await right_fighter.tree_entered
	
	left_fighter.global_position = fighter_0_spawn.global_position
	right_fighter.global_position = fighter_1_spawn.global_position
	
	left_fighter.player_id = 0
	right_fighter.player_id = 1
	
	left_fighter.opponent = right_fighter
	right_fighter.opponent = left_fighter
	
	_change_game_state(GameState.COUNTDOWN)

func _spawn_fighter(fighter_scene : PackedScene) -> Fighter:
	var fighter : Fighter = fighter_scene.instantiate()
	get_tree().root.get_node("Game").add_child.call_deferred(fighter)
	return fighter

func _on_countdown_timer_timeout() -> void:
	_change_game_state(GameState.PLAYING)


func _on_end_game_timer_timeout() -> void:
	SceneManager.load_menu()
