class_name FighterAnimation
extends Node

@export var animation_tree : AnimationTree


func set_blend_position(path : String, value : float):
	animation_tree[path] = lerp(animation_tree[path], value, 0.3)
	
	if NetworkManager.is_server:
		client_set_blend_position.rpc(path, value)

@rpc("authority", "call_remote", "reliable")
func client_set_blend_position(path : String, value : float):
	animation_tree[path] = lerp(animation_tree[path], value, 0.3)

func set_animation(animation_name : String):
	animation_tree["parameters/playback"].travel(animation_name)
	
	if NetworkManager.is_server:
		client_set_animation.rpc(animation_name)

@rpc("authority", "call_remote", "reliable")
func client_set_animation(animation_name : String):
	animation_tree["parameters/playback"].travel(animation_name)
