class_name AttackingState
extends State

@export var animation_name : String
@export var duration : float

@export var cooldown : float
var cooldown_end_time

@export var forward_force : float

func can_enter():
	if Time.get_unix_time_from_system() < cooldown_end_time:
		return false
		
	return true

func enter():
	super.enter()
	
	animation.set_animation(animation_name)
	fighter.add_force(forward_force * fighter.forward_direction)

func update(delta : float):
	super.update(delta)
	
	if time_since_entry >= duration:
		state_machine.change_state("Standing")

func exit():
	super.exit()
	cooldown_end_time = Time.get_unix_time_from_system() + cooldown
