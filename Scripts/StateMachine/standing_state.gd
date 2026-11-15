class_name StandingState
extends MovementState

func update(delta : float):
	super.update(delta)
	
	if input_buffer.is_pressed("jump"):
		state_machine.change_state("Jumping")
	
