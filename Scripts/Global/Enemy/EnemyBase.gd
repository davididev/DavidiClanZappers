class_name EnemyBase extends RigidBody3D

signal OnDamage(Amount : int);  #Enemies will need to use this

static var powPart = preload("res://Prefabs/preload/enemy_pow_particle.tscn");

var emissionColor : Color = Color.BLACK;
var targetColor : Color = Color.BLACK;

@export var renderers : Array[NodePath];
@export var look_at_transform : NodePath;
@export var TouchDamage = 2;
@export var MaxHealth = 6.0;
@export var tree : NodePath;
@export var brains : Array[NodePath];
@export var brainTransitions : Array[BrainTransition];
var currentBrainID = 0;
@export var IdleName : String;
@export var MoveName : String;
@export var AttackName : String;
@export var JumpName : String;
@export var MoveSpeed : float = 50.0;
@export var MaxVelocity : float = 10.0;
@export var JumpTowardsTarget = false;
@export var coinsOnDeath = 1;
@export var chanceOfHeart = 100;
var MinHealth = 6.0;

var SpeedMultiplier = 1.0;

var jumpTimer = 0.0;
var moveTimer = 0.0;
var attackTimer = 0.0;
var currentBrainTime = 0.0;

func SaveNode() -> SerializedNode:
	var newNode = SerializedNode.new();
	newNode.path = get_path();
	newNode.MiscFloat1 = MinHealth;
	newNode.MiscInt1 = currentBrainID;
	newNode.position = position;
	newNode.rotation = rotation_degrees;
	return newNode;

var loadFile = false;

func LoadNode(load2 : SerializedNode) -> void:
	loadFile = true;
	position = load2.position;
	rotation_degrees = load2.rotation;
	MinHealth = load2.MiscFloat1;
	SetCurrentBrain(load2.MiscInt1);
	if MinHealth < 0.0:
		Die();
		
func Die():
	visible = false;
	process_mode = ProcessMode.PROCESS_MODE_DISABLED;
	var remainingCoins = coinsOnDeath;
	while remainingCoins > 0:
		remainingCoins -= 1;
		var entry = Node3DPool.GetInstance("small_coin");
		if entry != null:
			entry.position = position + Vector3(randf_range(-1.5, 1.5), 0.0, randf_range(-1.5, 1.5));
	
	var chance = randi_range(0, 101);
	if chance <= chanceOfHeart:
		var entry = Node3DPool.GetInstance("small_heart");
		if entry != null:
			entry.position = position;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.05).timeout;
	if loadFile == false:  #This was not loaded from data, init enemy
		MinHealth = MaxHealth;
		SetCurrentBrain(0);
	pass # Replace with function body.

func SetCurrentBrain(id : int):
	currentBrainID = id;
	currentBrainTime = 0.0;
	for i in range(0, brains.size()):
		if i == currentBrainID:
			get_node(brains[i]).call("TurnOn");
		else:
			get_node(brains[i]).call("TurnOff");
	
func MoveTowardsPosition(pos : Vector3):
	var rel = (pos - position);
	var force = rel.normalized() * MoveSpeed * SpeedMultiplier;
	var isClose = false;
	if rel.length_squared() < 1.0:  #If close, slow it down
		force = force * 0.1;
		isClose = true;
		
	if JumpTowardsTarget == false:
		force.y = 0.0;
	if linear_velocity.length_squared() < MaxVelocity:
		apply_force(force);
	moveTimer = 0.1;
	get_node(look_at_transform).look_at(pos, Vector3(0.0, 1.0, 0.0), true);
	var targetAngle = get_node(look_at_transform).rotation_degrees.y;
	var currentAngle = get_child(0).rotation_degrees;
	currentAngle.y = move_toward(currentAngle.y, targetAngle, 360.0 * lastDelta);
	#print(str("Target angle: ", targetAngle, "; currently at ", currentAngle.y));
	
	get_child(0).rotation_degrees = currentAngle;
	return isClose;

var lastDelta = 0.0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lastDelta = delta;
	PlayAnim(delta);
	CheckBrainTransition(delta);
	ProcessFlash(delta);

func ProcessFlash(delta : float):
	if emissionColor != targetColor:
		emissionColor.r = move_toward(emissionColor.r, targetColor.r, 5.0 * delta);
		emissionColor.g = move_toward(emissionColor.g, targetColor.g, 5.0 * delta);
		emissionColor.b = move_toward(emissionColor.b, targetColor.b, 5.0 * delta);
		for tempnode in renderers:
			var mat = get_node(tempnode).get_surface_override_material(0);
			var standard = mat as StandardMaterial3D;
			standard.emission = emissionColor;
			get_node(tempnode).set_surface_override_material(0, standard);
	if emissionColor == targetColor:  #End of flash
		if targetColor != Color.BLACK:
			targetColor = Color.BLACK;
func CheckBrainTransition(delta : float):
	var cur : BrainTransition = brainTransitions[currentBrainID];
	var moveNext = false;
	if cur.cond == BrainTransition.Condition.HEALTH_PERCENTAGE:
		var perc = MinHealth / MaxHealth;
		var min1 = cur.values[0];
		var max1 = cur.values[1];
		if perc >= min1 && perc <= max1:
			moveNext = true;
	if cur.cond == BrainTransition.Condition.TIME_ELAPSED:
		currentBrainTime += delta;
		if currentBrainTime >= cur.values[0]:
			moveNext = true;
	
	if cur.cond == BrainTransition.Condition.PLAYER_WITHIN_DISTANCE:
		var distCheck = cur.values[0];
		var dist = position.distance_to(Avatar.PlayerPos);
		if dist <= distCheck:
			moveNext = true;
	
	if moveNext:
		get_node(brains[currentBrainID]).call("NextBrain");
	
func PlayAnim(delta: float):
	var stateMachine = get_node(tree)["parameters/playback"];
	if attackTimer > 0.0 && AttackName != "":
		stateMachine.travel(AttackName);
		attackTimer -= delta;
	if moveTimer <= 0.0 && IdleName != "":
		stateMachine.travel(IdleName);
	if moveTimer > 0.0 && MoveName != "":
		stateMachine.travel(MoveName);
		moveTimer -= delta;
	


func PlayAttackAnimation(time : float):
	attackTimer = time;


func _on_on_damage(Amount: int) -> void:
	if emissionColor == Color.BLACK:
		PopupText.PrintText(str("-", Amount, " HP"), get_tree(), Color.RED, position);
		targetColor = Color.RED;
		var inst = powPart.instantiate();
		get_tree().root.add_child(inst);
		inst.position = position;
		
		MinHealth -= Amount;
		if MinHealth < 0.0:
			Die();
		
		


func OnTouchDamage(body: Node) -> void:
	print(str("Slime colliding with ", body.name));
	if body.is_in_group("Player"):
		body.emit_signal("OnDamage", TouchDamage);
