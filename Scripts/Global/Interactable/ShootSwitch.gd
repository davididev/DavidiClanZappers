class_name ShootSwitch extends RigidBody3D

signal ToggleSwitch(status : bool);
signal OnDamage(Amount : int);  #Enemies will need to use this
@export var IsTurnedOn = false;
@export var turnedOffMat : Material;
@export var turnedOnMat : Material;
@export var MeshRend : NodePath;
@export var ToggleSwitches : Array[NodePath];

const IntensityPerSecond = 2.0;
const MinIntensity = 0.5;
const MaxIntensity = 2.0;
var goingTowardsMin = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SwitchStatus();
	
func SwitchStatus():
	if IsTurnedOn:
		get_node(MeshRend).set_surface_override_material(0, turnedOnMat);
		get_node("CollisionShape3D/OmniLight3D").light_color = Color.BLUE;
	else:
		get_node(MeshRend).set_surface_override_material(0, turnedOffMat);
		get_node("CollisionShape3D/OmniLight3D").light_color = Color.RED;
	
	for np in ToggleSwitches:
		get_node(np).emit_signal("ToggleSwitch", IsTurnedOn);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var currentIntensity = get_node("CollisionShape3D/OmniLight3D").light_energy;
	if goingTowardsMin == true:
		currentIntensity = move_toward(currentIntensity, MinIntensity, IntensityPerSecond * delta);
		if is_equal_approx(MinIntensity, currentIntensity):
			goingTowardsMin = false;
	else:
		currentIntensity = move_toward(currentIntensity, MaxIntensity, IntensityPerSecond * delta);
		if is_equal_approx(MaxIntensity, currentIntensity):
			goingTowardsMin = true;
	
	get_node("CollisionShape3D/OmniLight3D").light_energy = currentIntensity;


func _on_on_damage(Amount: int) -> void:
	IsTurnedOn = !IsTurnedOn;
	SwitchStatus();
	SoundFXPlayer.PlaySound("interface/confirmation_004.ogg", get_tree(), global_position);
