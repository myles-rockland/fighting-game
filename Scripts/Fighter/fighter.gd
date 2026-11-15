class_name Fighter
extends CharacterBody3D

@export var player_id : int

@export var input_handler : InputHandler
@export var input_buffer : InputBuffer

func _physics_process(delta: float):
	# Get input packet
	var input_packet : InputPacket = input_handler.get_input_packet()
	
	# Receive the input in the buffer
	input_buffer.receive_input(input_packet)
	
	# Process the input in the state machine
	
	# Update player's facing direction
	
	# Process movement
