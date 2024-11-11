extends Node3D

signal UpdateTargetY();
@export var TargetY = 0.0;
@export var MovePerSecond = 2.0;
@export var AllowSwimming = true;
var _targetY = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_targetY = global_position.y;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var v = global_position;
	v.y = move_toward(v.y, _targetY, MovePerSecond * delta);
	global_position = v;
	pass


func _on_update_target_y() -> void:
	_targetY = TargetY;
