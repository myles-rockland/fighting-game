class_name FighterVisual
extends Node

var models : Array[MeshInstance3D]

@export var hit_material : StandardMaterial3D
@export var model_root : Node3D

@onready var fighter : Fighter = $".."

@export var outfit_materials : Array[StandardMaterial3D]
@export var outfit_models : Array[MeshInstance3D]

func _ready():
	for child in model_root.find_children("*", "MeshInstance3D", true):
		models.append(child)
		
	GlobalEvents.fighter_damaged.connect(_hit_flash)
	
	if NetworkManager.is_connected:
		if fighter.is_server_fighter():
			_set_outfit(0)
		else:
			_set_outfit(1)
	else:
		_set_outfit(fighter.player_id)

func _hit_flash(fighter : Fighter):
	if self.fighter != fighter:
		return
	
	for model : MeshInstance3D in models:
		model.material_overlay = hit_material
		
	await get_tree().create_timer(0.05).timeout
	
	for model : MeshInstance3D in models:
		model.material_overlay = null

func _set_outfit(outfit_index : int):
	for model : MeshInstance3D in outfit_models:
		model.set_surface_override_material(0, outfit_materials[outfit_index])
