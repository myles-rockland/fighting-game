class_name AIBrain
extends Node

enum AttackPhase 
{
	NONE,
	WAITING,
	PERFORMING,
}

@export var fighter : Fighter 
@export var min_approach_distance : float = 0.4
@export var detector : AIDetector

@export var light_attack_range : float = 1.0
@export var heavy_attack_range : float = 1.2

@export var min_x_bounds : float = -4
@export var max_x_bounds : float = 4

@export_category("Personality")
@export_range(0.0, 1.0) var skill : float
@export_range(0.0, 1.0) var bravery : float

var fear : float = 0.0 
var attack_phase : AttackPhase = AttackPhase.NONE
var attack_type : int = 0

var opponent : Fighter:
	get: return fighter.opponent

var opponent_distance : float
var opponent_attacking : bool

var pursue_input_key : String:
	get: return "move_right" if fighter.forward_direction > 0 else "move_left"
	
var flee_input_key : String:
	get: return "move_right" if fighter.forward_direction < 0 else "move_left"

func _ready():
	detector.light_attack_detected.connect(_on_detected_light_attack)
	detector.heavy_attack_detected.connect(_on_detected_heavy_attack)
	GlobalEvents.fighter_damaged.connect(_on_fighter_damaged)

func _physics_process(delta : float):
	fear = move_toward(fear, 0.0, delta * 0.1)

func decide_inputs() -> Dictionary[String, bool]:
	var inputs : Dictionary[String, bool] = {}
	
	opponent_distance = fighter.global_position.distance_to(opponent.global_position)
	
	if _against_level_bounds():
		fear = 0
	
	# If we are jumping, flee
	if fighter.state_machine.is_current_state("Jumping"):
		inputs[flee_input_key] = true
		return inputs
	
	# Performing an attack
	if attack_phase == AttackPhase.PERFORMING:
		attack_phase = AttackPhase.NONE
		
		if attack_type == 1:
			inputs["light_attack"] = true
		elif attack_type == 2:
			inputs["heavy_attack"] = true
			
		return inputs
	
	# If the opponent is attacking, dodge maybe
	if opponent_attacking:
		var dodge : int = _dodge_attack()
		
		if dodge > 0:
			inputs[flee_input_key] = true
			
			if dodge == 1:
				inputs["jump"] = true
			elif dodge == 2:
				inputs["dash"] = true
				
			return inputs
		
		opponent_attacking = false
	
	# If we don't have the advantage, flee
	if not _has_advantage():
		inputs[flee_input_key] = true
		return inputs
	
	# Preparing to attack
	if attack_phase == AttackPhase.NONE:
		var attack : int = _decide_attack()
		
		if attack > 0:
			_on_wait_to_attack(attack)
	
	# If the opponent is too far away, pursue them
	if opponent_distance > min_approach_distance:
		inputs[pursue_input_key] = true
	
	return inputs

func _on_detected_light_attack():
	opponent_attacking = true
	
func _on_detected_heavy_attack():
	opponent_attacking = true

func _on_wait_to_attack(attack : int):
	attack_type = attack
	attack_phase = AttackPhase.WAITING
	await detector.response_time_delay()
	attack_phase = AttackPhase.PERFORMING

func _dodge_attack() -> int:
	if not opponent_attacking:
		return 0
		
	if opponent_distance > 1.5:
		return 0
		
	var skill_check : bool = randf() < skill
	
	if not skill_check:
		return 0
		
	var dodge_type : int = randi_range(1, 2)
	
	return dodge_type

func _on_fighter_damaged(damaged_fighter : Fighter):
	if damaged_fighter != fighter:
		return
		
	fear += 0.2
	fear = clampf(fear, 0.0, 1.0)

func _has_advantage() -> bool:
	var health_difference = (fighter.current_health - opponent.current_health) / fighter.max_health
	if fear > bravery or health_difference < -bravery:
		return false
	else:
		return true

func _decide_attack() -> int:
	if opponent_distance > heavy_attack_range:
		return 0
		
	var do_perfect_attack : bool = randf() < skill
	
	if do_perfect_attack:
		if opponent_distance > light_attack_range and opponent_distance <= heavy_attack_range:
			return 2
		else:
			return 1
			
	if randf() < skill:
		return randi_range(1, 2)
		
	return 0
	
func _against_level_bounds() -> bool:
	var x = fighter.global_position.x
	return x < min_x_bounds or x > max_x_bounds
