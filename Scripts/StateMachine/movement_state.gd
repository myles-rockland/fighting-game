class_name MovementState
extends State

@export var move_speed : float = 1.5
@export var blend_position_parameter : String

func update(delta : float):
	super.update(delta)
	
	# Set movement direction
	var move_direction : int = input_buffer.move_direction()
	fighter.move_velocity.x = move_direction * move_speed
	
	# Blend the animation
	if blend_position_parameter.length() == 0:
		return
		
	var blend_pos : float = move_direction * fighter.forward_direction
	animation.set_blend_position(blend_position_parameter, blend_pos)
