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
		
	set_screen(start_screen)
		
func set_screen(screen : MenuScreen):
	if current_screen:
		current_screen.close()
		current_screen.visible = false
		
	current_screen = screen
	current_screen.visible = true
	current_screen.open()
