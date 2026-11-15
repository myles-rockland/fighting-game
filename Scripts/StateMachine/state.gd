class_name State
extends Node

var state_machine : StateMachine

var entry_time : float
var time_since_entry : float

func initialise(state_machine : StateMachine):
	self.state_machine = state_machine
	
func can_enter() -> bool:
	return true
	
func enter():
	entry_time = Time.get_unix_time_from_system()

func exit():
	pass

func update(delta : float):
	var time : float = Time.get_unix_time_from_system()
	time_since_entry = time - entry_time
