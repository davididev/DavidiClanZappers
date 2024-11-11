extends RigidBody3D

signal ToggleSwitch(status : bool);

@export var IsMoving = true;
@export var TargetOffset : Vector3;
@export var VelocityPerSecond = 2.5;

@export var startingPos = Vector3.ZERO;
var endingPos = Vector3.ZERO;
var goingTowardEndingPos = true;

func SaveNode() -> SerializedNode:
	var newNode = SerializedNode.new();
	newNode.position = position;
	newNode.rotation = rotation_degrees;
	newNode.path = get_path();
	if IsMoving:
		newNode.MiscInt1 = 1;
	else:
		newNode.MiscInt1 = 0;
	return newNode;


func LoadNode(load2 : SerializedNode) -> void:
	position = load2.position;
	rotation_degrees = load2.rotation;
	if load2.MiscInt1 == 1:
		IsMoving = true;
	if load2.MiscInt1 == 0:
		IsMoving = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	endingPos = startingPos + TargetOffset;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if IsMoving == false:
		linear_velocity = Vector3.ZERO;
	if IsMoving == true:
		var targetPos = endingPos;
		if goingTowardEndingPos == false:
			targetPos = startingPos;
		
		var distThres = VelocityPerSecond * delta * 2.0;
		var dist = global_position.distance_to(targetPos);
		if dist <= distThres:
			goingTowardEndingPos = !goingTowardEndingPos;
			linear_velocity = Vector3.ZERO;
		else:
			var rel = (targetPos - global_position).normalized() * VelocityPerSecond;
			linear_velocity = rel;


func _on_toggle_switch(status: bool) -> void:
	IsMoving = status; 
