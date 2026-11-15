class_name MovementState
extends State

@export var move_speed : float = 1.5

func update(delta : float):
	super.update(delta)
	
	var move_direction : int = input_buffer.move_direction()
	
	fighter.move_velocity.x = move_direction * move_speed
