class_name Fighter
extends CharacterBody3D

@export var player_id : int
@export var opponent : Fighter

@export var input_handler : InputHandler
@export var input_buffer : InputBuffer
@export var state_machine : StateMachine

var forward_direction : int
var move_velocity : Vector3
var horizontal_force : float
var drag : float = 0.8

func _ready():
	for child in find_children("*", "HitReceiver", true, false):
		child.initialise(self)
	
	for child in find_children("*", "HitSender", true, false):
		child.initialise(self)
	
func _physics_process(delta: float):
	# Get input packet
	var input_packet : InputPacket = input_handler.get_input_packet()
	
	# Receive the input in the buffer
	input_buffer.receive_input(input_packet)
	
	# Process the input in the state machine
	state_machine.update(delta)
	
	# Update player's facing direction
	_update_facing_direction()
	
	# Process movement
	_movement(delta)

func _update_facing_direction():
	if global_position.x < opponent.global_position.x:
		forward_direction = 1
		rotation_degrees.y = 90
	else:
		forward_direction = -1
		rotation_degrees.y = -90

func add_force(force : float):
	horizontal_force += force

func _movement(delta : float):
	horizontal_force *= drag
	
	velocity.x = move_velocity.x + horizontal_force
	velocity.y = move_velocity.y
	move_and_slide()

func take_damage(hit_receiver : HitReceiver, damage_amount : float):
	state_machine.change_state(hit_receiver.hit_state_name)
	add_force(forward_direction * -10)
