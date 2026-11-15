class_name StandingState
extends MovementState

func update(delta : float):
	super.update(delta)
	
	if input_buffer.was_pressed("light_attack", 5):
		state_machine.change_state("LightAttack")
		return
		
	if input_buffer.was_pressed("heavy_attack", 5):
		state_machine.change_state("HeavyAttack")
		return
	
	if input_buffer.is_pressed("jump"):
		state_machine.change_state("Jumping")
		return
		
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("Dashing")
		return
	
