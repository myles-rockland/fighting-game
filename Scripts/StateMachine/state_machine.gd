class_name StateMachine
extends Node

@export var starting_state : State

@export var fighter : Fighter
@export var input_buffer : InputBuffer
# animation
# stamina controller

var states : Dictionary[String, State] = { }
var current_state : State

func _ready():
	for child in get_children():
		if child is not State:
			continue
		
		states[child.name] = child
		child.initialise(self)
	
	if starting_state:
		change_state(starting_state.name)

func change_state(state_name : String):
	if not states.has(state_name):
		printerr("Cannot change state to ", state_name, " as it doesn't exist!")
		return
		
	if current_state:
		current_state.exit()
		
	current_state = states[state_name]
	current_state.enter()
	
	print("New State: ", state_name)
