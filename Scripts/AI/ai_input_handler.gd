class_name AIInputHandler
extends InputHandler

@export var brain : AIBrain

func get_input_packet() -> InputPacket:
	var packet : InputPacket = InputPacket.new()
	packet.inputs = brain.decide_inputs()
	return packet
