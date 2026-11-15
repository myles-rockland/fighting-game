class_name FighterAnimation
extends Node

@export var animation_tree : AnimationTree

func set_blend_position(path : String, value : float):
	animation_tree[path] = lerp(animation_tree[path], value, 0.3)

func set_animation(animation_name : String):
	animation_tree["parameters/playback"].travel(animation_name)
