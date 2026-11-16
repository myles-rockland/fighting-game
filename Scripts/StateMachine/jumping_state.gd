class_name JumpingState
extends MovementState

@export var jump_force : float = 5.0
@export var gravity : float = 10.0

func can_enter() -> bool:
	return stamina_controller.current_stamina >= stamina_data.jump_cost

func enter():
	fighter.move_velocity.y = jump_force
	animation.set_animation("JumpStart")
	stamina_controller.consume_stamina(stamina_data.jump_cost)
	signals.began_jump.emit()

func update(delta : float):
	fighter.move_velocity.y -= gravity * delta
	
	super.update(delta)
	
	if fighter.is_on_floor():
		state_machine.change_state("Standing")

func exit():
	fighter.move_velocity.y = 0
	animation.set_animation("JumpLand")
