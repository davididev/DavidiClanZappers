class_name EnemyBase extends RigidBody3D

signal OnDamage(Amount : int);  #Enemies will need to use this
signal OnDeath();
signal KillRemotely();

static var powPart = preload("res://Prefabs/preload/enemy_pow_particle.tscn");

var emissionColor : Color = Color.BLACK;
var targetColor : Color = Color.BLACK;

@export var renderers : Array[NodePath];
@export var look_at_transform : NodePath;
@export var TouchDamage = 2;
@export var Defense = 0;
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
@export var minCoinsOnDeath = 1;
@export var maxCoinsOnDeath = 1;
@export var chanceOfHeart = 100;
@export var dialogueOnDeath : DialogueGrid;
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
		visible = false;
		process_mode = ProcessMode.PROCESS_MODE_DISABLED;
		
func KillWithoutSpoils():
	visible = false;
	#process_mode = ProcessMode.PROCESS_MODE_DISABLED;
	
func Die():
	visible = false;
	process_mode = ProcessMode.PROCESS_MODE_DISABLED;
	var remainingCoins = randi_range(minCoinsOnDeath, maxCoinsOnDeath);
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
	
	OnDeath.emit();
	if dialogueOnDeath != null:
		DialogueHandler.Instance.StartDialogue(dialogueOnDeath);
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jumpTimer = 0.0;
	moveTimer = 0.0;
	attackTimer = 0.0;
	currentBrainTime = 0.0;
	emissionColor = Color.BLACK;
	targetColor = Color.BLACK;
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
	get_node(look_at_transform).look_at(to_local(pos), Vector3(0.0, 1.0, 0.0), true);
	var targetAngle = get_node(look_at_transform).rotation_degrees.y;
	var currentAngle = get_child(0).rotation_degrees;
	#currentAngle.y = move_toward(currentAngle.y, targetAngle, 360.0 * lastDelta);
	
	var dif = angle_difference(deg_to_rad(currentAngle.y), deg_to_rad(targetAngle));
	var difAngles = rad_to_deg(dif);
	#print("Current angle: ", currentAngle.y, " target angle: ", targetAngle, " Dif: ", difAngles)
	
	
	if difAngles < 0:
		var rel2 = -360.0 * lastDelta;
		if rel2 < difAngles:
			rel2 = difAngles;
		currentAngle.y += rel2;
	if difAngles > 0:
		var rel2 = 360.0 * lastDelta;
		if rel2 > difAngles:
			rel2 = difAngles;
		currentAngle.y += rel2;
	
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
	var conditionsTrue = 0;
	var maxConditions = cur.cond.size();
	for i in range(0, maxConditions):
		if cur.cond[i] == BrainTransition.Condition.HEALTH_PERCENTAGE_LESS:
			var perc = MinHealth / MaxHealth;
			var min1 = cur.values[i];
			if perc <= min1:
				conditionsTrue += 1;
		if cur.cond[i] == BrainTransition.Condition.TIME_ELAPSED:
			currentBrainTime += delta;
			if currentBrainTime >= cur.values[i]:
				conditionsTrue += 1;
		if cur.cond[i] == BrainTransition.Condition.PLAYER_WITHIN_DISTANCE:
			var distCheck = cur.values[i];
			var dist = position.distance_to(Avatar.PlayerPos);
			if dist <= distCheck:
				conditionsTrue += 1;
	
	if cur.operator == BrainTransition.Operator.ALL_TRUE && conditionsTrue >= maxConditions:
		get_node(brains[currentBrainID]).call("NextBrain");
	if cur.operator == BrainTransition.Operator.ONE_OR_MORE_TRUE && conditionsTrue >= 1:
		get_node(brains[currentBrainID]).call("NextBrain");
	if cur.operator == BrainTransition.Operator.NONE_TRUE && conditionsTrue == 0:
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
	Amount -= Defense;
	if Amount < 0:
		Amount = 0;
	if emissionColor == Color.BLACK:
		PopupText.PrintText(str("-", Amount, " HP"), get_tree(), Color.RED, position);
		if Amount > 0:
			targetColor = Color.RED;
			var inst = powPart.instantiate();
			get_tree().root.add_child(inst);
			inst.position = position;
		
			MinHealth -= Amount;
			if MinHealth < 0.0:
				Die();
			


func OnTouchDamage(body: Node) -> void:
	#print(str("Slime colliding with ", body.name));
	if body.is_in_group("Player"):
		body.emit_signal("OnDamage", TouchDamage);
