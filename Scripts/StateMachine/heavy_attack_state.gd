class_name HeavyAttackState
extends AttackingState

func _stamina_cost() -> float:
	return stamina_data.heavy_attack_cost

func enter():
	super.enter()
	signals.began_heavy_attack.emit()
