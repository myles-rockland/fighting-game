class_name StaminaController
extends Node

signal stamina_updated(value : float)

@export var data : StaminaData

var current_stamina : float
var can_regen : bool = false

@onready var regen_timer : Timer = $StaminaRegenTimer

func _ready():
	regen_timer.wait_time = data.regen_delay
	_set_stamina(data.max_stamina)

func _physics_process(delta: float) -> void:
	if not can_regen:
		return
		
	var new_stamina : float = move_toward(current_stamina, data.max_stamina, data.regen_rate * delta)
	_set_stamina(new_stamina)

func _set_stamina(value : float):
	current_stamina = value
	stamina_updated.emit(current_stamina)

func consume_stamina(amount : float):
	_set_stamina(current_stamina - amount)
	can_regen = false
	regen_timer.stop()
	regen_timer.start()

func _on_stamina_regen_timer_timeout() -> void:
	can_regen = true
