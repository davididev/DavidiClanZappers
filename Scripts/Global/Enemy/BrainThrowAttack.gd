class_name Brain_FireBullet extends Node3D

@export var root : NodePath;
@export var nextBrainID = 1;
@export var BulletPrefab : PackedScene;
@export var BulletPrefabName : String;
@export var DelayBeforeFire = 0.1;
var isRunning = false;
var delay = 0.0;

# These are common functions that should be called by the EnemyBase.
func TurnOn() -> void:
	isRunning = true;
	Node3DPool.InitPoolItem(get_tree(), BulletPrefabName, BulletPrefab, 20);
	delay = 0.0;

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
		delay += delta;
		if delay > DelayBeforeFire:
			get_node(root).PlayAttackAnimation(1.0);
			var inst = Node3DPool.GetInstance(BulletPrefabName);
			inst.global_position = global_position;
			inst.global_rotation_degrees = get_node(root).global_rotation_degrees;
			delay = -100.0;  #Don't run it twice, this is meant to be run once.
