extends Node

# Server signals
signal player_connected(id : int)
signal player_disconnected(id : int)

# Client signals
signal connected_to_server
signal connected_failed
signal server_disconnected

func start_host(port : int):
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(port, 2)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	
	_peer_connected(peer.get_unique_id())
	_connected_to_server()
	
func _peer_connected(id : int):
	player_connected.emit(id)
	
func _peer_disconnected(id : int):
	player_disconnected.emit(id)
	
func start_client(ip : String, port : int):
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)

func _connected_to_server():
	connected_to_server.emit()
	
func _connection_failed():
	connected_failed.emit()
	
func _server_disconnected():
	server_disconnected.emit()

func close_peer():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
