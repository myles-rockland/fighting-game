class_name Menu
extends CanvasLayer

@export var start_screen : MenuScreen
var screens : Array[MenuScreen] = []
var current_screen : MenuScreen

func _ready():
	for child in get_children():
		if child is not MenuScreen:
			continue
			
		screens.append(child)
		child.visible = false
		
	if NetworkManager.is_connected:
		set_screen($MultiplayerLobbyScreen)
	else:
		set_screen(start_screen)
	
	NetworkManager.connected_to_server.connect(_on_connected_to_server)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
		
func set_screen(screen : MenuScreen):
	if current_screen:
		current_screen.close()
		current_screen.visible = false
		
	current_screen = screen
	current_screen.visible = true
	current_screen.open()

func _on_connected_to_server():
	set_screen($MultiplayerLobbyScreen)
	
func _on_server_disconnected():
	set_screen($MainMenuScreen)
