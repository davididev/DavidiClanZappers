class_name  PlayerLamp extends Node3D

var current_energy = 1.0;
var energy_target = 1.0;
const MIN_ENERGY = 0.25;
const MAX_ENERGY = 1.5;
const ENERGY_PER_SECOND = 0.25;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SetRadius(r : float):
	get_node("OmniLight3D").omni_range = r;
	current_energy = 1.0;
	energy_target = 1.0;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Avatar.PlayerPos + Vector3(0.0, 1.0, 0.0);
	if current_energy == energy_target:
		energy_target = randf_range(MIN_ENERGY, MAX_ENERGY);
	else:
		current_energy = move_toward(current_energy, energy_target, ENERGY_PER_SECOND * delta);
		get_node("OmniLight3D").light_energy = current_energy;
