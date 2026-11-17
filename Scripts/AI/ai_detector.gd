class_name AIDetector
extends Node

signal light_attack_detected
signal heavy_attack_detected

@export var fighter : Fighter

@export var min_response_time : float
@export var max_response_time : float

func _ready():
	var opponent_signals : FighterSignals = fighter.opponent.signals
	
	opponent_signals.began_light_attack.connect(_on_opponent_began_light_attack)
	opponent_signals.began_heavy_attack.connect(_on_opponent_began_heavy_attack)

func _on_opponent_began_light_attack():
	await response_time_delay()
	light_attack_detected.emit()
	
func _on_opponent_began_heavy_attack():
	await response_time_delay()
	heavy_attack_detected.emit()
	
func response_time_delay():
	var time : float = randf_range(min_response_time, max_response_time)
	await get_tree().create_timer(time).timeout
