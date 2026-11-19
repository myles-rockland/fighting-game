extends Node

signal scene_changed

var menu_scene : PackedScene = preload("res://Scenes/menu.tscn")
var game_scene : PackedScene = preload("res://Scenes/game.tscn")

var current_scene : Node
var loading : bool = false

@rpc("authority", "call_local", "reliable")
func load_menu():
	_load_scene(menu_scene)
	
@rpc("authority", "call_local", "reliable")
func load_game():
	_load_scene(game_scene)

func _load_scene(scene : PackedScene):
	if loading:
		return
		
	loading = true
	
	if is_instance_valid(current_scene):
		current_scene.queue_free()
		await current_scene.tree_exited
	
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	
	if not current_scene.is_inside_tree():
		await current_scene.tree_entered
		
	loading = false
	scene_changed.emit()
