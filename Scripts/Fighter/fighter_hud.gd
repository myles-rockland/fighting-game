extends Panel

@onready var fighter : Fighter = $"../.."

@onready var health_bar : ProgressBar = $HudElements/HealthBar
@onready var health_text : Label = $HudElements/HealthBar/HealthText

@onready var stamina_bar : ProgressBar = $HudElements/StaminaBar

@onready var player_0_pos : Control = $"../Player0Pos"
@onready var player_1_pos : Control = $"../Player1Pos"

@onready var stamina_controller : StaminaController = $"../../StaminaController"

func _ready():
	
	if NetworkManager.is_connected:
		if fighter.is_server_fighter():
			position = player_0_pos.position
		else:
			position = player_1_pos.position
	else:
		if fighter.player_id == 0:
			position = player_0_pos.position
		elif fighter.player_id == 1:
			position = player_1_pos.position
		
	# Health bar
	health_bar.max_value = fighter.max_health
	_update_health_bar(fighter)
	
	# Stamina bar
	stamina_bar.max_value = stamina_controller.data.max_stamina
	stamina_controller.stamina_updated.connect(_update_stamina_bar)
	
	# Events
	GlobalEvents.fighter_damaged.connect(_update_health_bar)

func _update_stamina_bar(stamina : float):
	stamina_bar.value = stamina

func _update_health_bar(damaged_fighter : Fighter):
	if damaged_fighter != fighter:
		return
		
	health_bar.value = fighter.current_health
	health_text.text = str(int(fighter.current_health))
