class_name GameManager
extends Node

enum GameState
{
	LOADING,
	COUNTDOWN,
	PLAYING,
	ENDED,
}

@onready var countdown_animation : AnimationPlayer = $CountdownCanvasLayer/CountdownAnimation
@onready var countdown_timer : Timer = $CountdownTimer

@onready var end_game_text : Label = $CountdownCanvasLayer/EndGameText
@onready var end_game_timer : Timer = $EndGameTimer

var current_game_state : GameState

func _ready():
	GlobalEvents.fighter_defeated.connect(_on_fighter_defeated)
	
	_change_game_state(GameState.COUNTDOWN)

func _change_game_state(game_state : GameState):
	current_game_state = game_state
	
	if game_state == GameState.COUNTDOWN:
		countdown_animation.play("countdown")
		countdown_timer.start()
	elif game_state == GameState.ENDED:
		end_game_timer.start()
		
	GlobalEvents.game_state_changed.emit(current_game_state)

func _on_fighter_defeated(fighter : Fighter):
	_change_game_state(GameState.ENDED)
	
	end_game_text.visible = true
	
	if fighter.player_id == 0:
		end_game_text.text = "Player 2 Wins"
	else:
		end_game_text.text = "Player 1 Wins"


func _on_countdown_timer_timeout() -> void:
	_change_game_state(GameState.PLAYING)


func _on_end_game_timer_timeout() -> void:
	print("Go to menu")
