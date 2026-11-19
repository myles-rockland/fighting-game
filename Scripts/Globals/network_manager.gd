extends Node

# Server signals
signal player_connected(id : int)
signal player_disconnected(id : int)

# Client signals
signal connected_to_server
signal connected_failed
signal server_disconnected

@onready var player_spawner : MultiplayerSpawner = get_tree().root.get_node("/root/Bootstrap/PlayerMultiplayerSpawner")
var player_scene : PackedScene = preload("res://Scenes/network_player.tscn")

var player_host : NetworkPlayer
var player_client : NetworkPlayer

var local_username : String

var is_server : bool:
	get: return multiplayer.is_server()

var peer_id : int:
	get: return multiplayer.get_unique_id()

func start_host(port : int):
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(port, 2)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	
	_peer_connected(peer.get_unique_id())
	_connected_to_server()
	
func _peer_connected(id : int):
	var player : NetworkPlayer = player_scene.instantiate()
	player.name = str(id)
	player_spawner.add_child(player)
	
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

func register_player_node(player : NetworkPlayer):
	if player.get_multiplayer_authority() == 1:
		player_host = player_client
	else:
		player_client = player
