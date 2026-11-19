class_name Fighter
extends CharacterBody3D

@export var player_id : int
@export var opponent : Fighter

@export var current_health : float = 100
@export var max_health : float = 100


@export var input_handler : InputHandler
@export var input_buffer : InputBuffer
@export var state_machine : StateMachine
@export var signals : FighterSignals

var forward_direction : int
var move_velocity : Vector3
var horizontal_force : float
var drag : float = 0.8
var is_defeated : bool = false
var is_invulnerable : bool = false
var can_control : bool = false

@export var take_damage_sfx : AudioStream

func _enter_tree() -> void:
	if NetworkManager.is_connected:
		$InputSync.set_multiplayer_authority(name.to_int())

func is_server_fighter() -> bool:
	return $InputSync.get_multiplayer_authority() == 1

func _ready():
	if NetworkManager.is_connected and not NetworkManager.is_server:
		set_physics_process(false)
		return
	
	GlobalEvents.game_state_changed.connect(_on_game_state_changed)
	
	_intialise.call_deferred()
	
func _intialise():
	GlobalEvents.fighter_spawned.emit(self)
	_update_facing_direction()
	
	for child in find_children("*", "HitReceiver", true, false):
		child.initialise(self)
	
	for child in find_children("*", "HitSender", true, false):
		child.initialise(self)
	
func _physics_process(delta: float):
	if not can_control:
		return
	
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
	if is_defeated or is_invulnerable:
		return
		
	current_health -= damage_amount
	GlobalEvents.fighter_damaged.emit(self)
	AudioManager.play(take_damage_sfx)
	
	if current_health <= 0:
		current_health = 0
		defeat()
	else:
		state_machine.change_state(hit_receiver.hit_state_name)
		add_force(forward_direction * -10)

func defeat():
	is_defeated = true
	state_machine.change_state("Defeated")
	GlobalEvents.fighter_defeated.emit(self)

func _on_game_state_changed(game_state : GameManager.GameState):
	if game_state == GameManager.GameState.PLAYING:
		can_control = true
