extends Camera3D

@export var target_a : Node3D
@export var target_b : Node3D

@export var smoothing : float
@export var zoom_curve : Curve

var intensity : float = 0.0

@export var shake_amount : float = 0.05
@export var shake_damping : float = 10.0

func _ready():
	GlobalEvents.fighter_damaged.connect(_on_fighter_damaged)
	GlobalEvents.fighter_spawned.connect(_on_fighter_spawned)

func _on_fighter_damaged(fighter : Fighter):
	intensity = shake_amount

func _physics_process(delta : float):
	_camera_follow(delta)
	
	if intensity > 0:
		intensity = lerpf(intensity, 0.0, delta * shake_damping)
		h_offset = randf_range(-intensity, intensity)
		v_offset = randf_range(-intensity, intensity)

func _camera_follow(delta : float):
	if not target_a or not target_b:
		return
	
	var center_pos : Vector3 = target_a.global_position.lerp(target_b.global_position, 0.5)
	var distance : float = target_a.global_position.distance_to(target_b.global_position)
	
	position.x = lerp(position.x, center_pos.x, smoothing * delta)
	
	position.z = zoom_curve.sample(distance)

func _on_fighter_spawned(fighter : Fighter):
	if not target_a:
		target_a = fighter
	else:
		target_b = fighter
