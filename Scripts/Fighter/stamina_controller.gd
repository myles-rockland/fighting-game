class_name StaminaController
extends Node

signal stamina_updated(value : float)

@export var data : StaminaData

var current_stamina : float
var can_regen : bool = false

@onready var regen_timer : Timer = $StaminaRegenTimer

func _ready():
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)
	
	regen_timer.wait_time = data.regen_delay
	
	if not NetworkManager.is_connected:
		_set_stamina(data.max_stamina)
	
	if NetworkManager.is_connected and not NetworkManager.is_server:
		set_physics_process(false)

func _on_game_state_changed(game_state : GameManager.GameState):
	if game_state == GameManager.GameState.COUNTDOWN and NetworkManager.is_connected:
		_set_stamina(data.max_stamina)

func _physics_process(delta: float) -> void:
	if not can_regen:
		return
		
	var new_stamina : float = move_toward(current_stamina, data.max_stamina, data.regen_rate * delta)
	_set_stamina(new_stamina)

func _set_stamina(value : float):
	current_stamina = value
	stamina_updated.emit(current_stamina)
	
	if NetworkManager.is_connected:
		client_set_stamina.rpc(current_stamina)

@rpc("authority", "call_remote", "reliable")
func client_set_stamina(new_stamina : float):
	current_stamina = new_stamina
	stamina_updated.emit(current_stamina)

func consume_stamina(amount : float):
	_set_stamina(current_stamina - amount)
	can_regen = false
	regen_timer.stop()
	regen_timer.start()

func _on_stamina_regen_timer_timeout() -> void:
	can_regen = true
