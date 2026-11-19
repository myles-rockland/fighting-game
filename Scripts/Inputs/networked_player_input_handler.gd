class_name NetworkedPlayerInputHandler
extends PlayerInputHandler

@export var move_left : bool
@export var move_right : bool
@export var jump : bool
@export var dash : bool
@export var light_attack : bool
@export var heavy_attack : bool

func _ready():
	if $"..".get_multiplayer_authority() != NetworkManager.peer_id:
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	var packet : InputPacket = super.get_input_packet()
	
	move_left = packet.inputs["move_left"]
	move_right = packet.inputs["move_right"]
	jump = packet.inputs["jump"]
	dash = packet.inputs["dash"]
	light_attack = packet.inputs["light_attack"]
	heavy_attack = packet.inputs["heavy_attack"]

func get_input_packet() -> InputPacket:
	var packet : InputPacket = InputPacket.new()
	
	packet.inputs["move_left"] = move_left
	packet.inputs["move_right"] = move_right
	packet.inputs["jump"] = jump
	packet.inputs["dash"] = dash
	packet.inputs["light_attack"] = light_attack
	packet.inputs["heavy_attack"] = heavy_attack
	
	return packet
