class_name Brain_FollowPlayer extends Node3D

@export var root : NodePath;
@export var nextBrainID = 1;
@export var SpeedMultiplier = 1.5;
var isRunning = false;

# These are common functions that should be called by the EnemyBase.
func TurnOn() -> void:
	isRunning = true;
	get_node(root).SpeedMultiplier = SpeedMultiplier;

# These are common functions that should be called by the EnemyBase.	
func TurnOff() -> void:
	isRunning = false;

# These are common functions that should be called by the EnemyBase.
func NextBrain() -> void:
	get_node(root).SetCurrentBrain(nextBrainID);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isRunning:
		get_node(root).MoveTowardsPosition(Avatar.PlayerPos);
