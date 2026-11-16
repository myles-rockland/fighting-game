class_name LightAttackState
extends AttackingState

func _stamina_cost() -> float:
	return stamina_data.light_attack_cost

func enter():
	super.enter()
	signals.began_light_attack.emit()
