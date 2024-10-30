class_name Brain_WaitForPlayer extends Node3D

@export var radius = Vector2(2.0, 2.0);
@export var root : NodePath;
@export var waitBetweenMovement = 5.0;
@export var nextBrainID = 1;
var waitTimer = 0.0;
var startingPos : Vector3;

var isRunning = false;
var targetPos : Vector3;

# These are common functions that should be called by the EnemyBase.
func TurnOn() -> void:
	isRunning = true;
	startingPos = get_node(root).global_position;

# These are common functions that should be called by the EnemyBase.	
func TurnOff() -> void:
	isRunning = false;

# These are common functions that should be called by the EnemyBase.
func NextBrain() -> void:
	get_node(root).SetCurrentBrain(nextBrainID);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isRunning:
		if targetPos == Vector3.ZERO:
			targetPos = startingPos + Vector3(randf_range(-radius.x, radius.x), 0.0, randf_range(-radius.y, radius.y));
			waitTimer = 5.0;
		else:
			if waitTimer <= 0.0:
				var isClose = get_node(root).MoveTowardsPosition(targetPos);
				if isClose:
					targetPos = Vector3.ZERO;
		if waitTimer > 0.0:
			waitTimer -= delta;
			
