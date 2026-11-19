class_name Bootstrap
extends Node

func _ready():
	await get_tree().process_frame
	SceneManager.load_menu()
