class_name DashingState
extends State

@export var distance : float
@export var duration : float
@export var cooldown : float
var cooldown_end_time : float
var move_direction : int

func can_enter() -> bool:
	if input_buffer.move_direction() == 0:
		return false
		
	if Time.get_unix_time_from_system() < cooldown_end_time:
		return false
		
	return true

func enter():
	super.enter()
	
	fighter.move_velocity = Vector3.ZERO
	# TODO: Make fighter invulnerable
	
	move_direction = input_buffer.move_direction()
	animation.set_animation("Dash")

func update(delta : float):
	super.update(delta)
	
	if time_since_entry >= duration:
		state_machine.change_state("Standing")
		return
		
	var speed : float = distance / duration
	fighter.move_velocity.x = speed * move_direction

func exit():
	super.exit()
	
	fighter.move_velocity = Vector3.ZERO
	# TODO: Make fighter vulnerable
	cooldown_end_time = Time.get_unix_time_from_system() + cooldown
