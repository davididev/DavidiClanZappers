class_name Avatar extends CharacterBody3D

signal OnDamage(Amount : int);  #Enemies will need to use this

var CheckpointPosition = Vector3.ZERO;

static var AttackAnimTime = -1.0;
var damageDelay : float = -1.0;
@export var itemAttachment : NodePath;
@export var spellAttachment : NodePath;
@export var npcAnimatorRef : NodePath;
@export var rendNode : NodePath;
static var PlayerPos : Vector3;
static var AttachedItem = 0;
static var AttachedSpell = 0;

var idLeft = 0;
var idRight = 0;
var emissionColor : Color = Color.BLACK;
var targetColor : Color = Color.BLACK;

func TeleportToCheckpoint():
	global_position = CheckpointPosition;

func _enter_tree() -> void:
	CheckpointPosition = global_position;
	if GameDataHolder.Instance == null:
		GameDataHolder.Instance.LoadFile();
	UpdateUI();
	#Assuming attached items / spells aren't nil, carry from previous maps
	await get_tree().create_timer(0.1).timeout;
	AttachItem();
	AttachSpell();

func _process(delta: float) -> void:
	PlayerPos = global_position;
	if AttackAnimTime > -1.0:
		AttackAnimTime -= delta;
		
	if AttachedItem > 0:
		#Prepare animations
		if Input.is_action_just_pressed("item"):
			get_node(npcAnimatorRef).PlayAttackAnim();
			get_node(itemAttachment).get_child(0).call("UseItem");
			AttackAnimTime = 0.6;
	if AttachedSpell > 0:
		if Input.is_action_just_pressed("magic"):
			if PlayerUI.minTimerMagic >= PlayerUI.maxTimerMagic:
				get_node(npcAnimatorRef). PlaySpellAnim();
				PlayerUI.minTimerMagic = 0.0;
				get_node(spellAttachment).get_child(0).call("UseSpell");
				AttackAnimTime = 0.6;
	
	
	emissionColor.r = move_toward(emissionColor.r, targetColor.r, 4.0 * delta);
	emissionColor.g = move_toward(emissionColor.g, targetColor.g, 4.0 * delta);
	emissionColor.b = move_toward(emissionColor.b, targetColor.b, 4.0 * delta);
	var mat = get_node(rendNode).get_surface_override_material(0);
	var standard = mat as StandardMaterial3D;
	standard.emission = emissionColor;
	get_node(rendNode).set_surface_override_material(0, standard);
	if damageDelay > -1.0:
		damageDelay -= delta;
	
	if emissionColor == targetColor:  #End of flash
		if targetColor != Color.BLACK:
			targetColor = Color.BLACK;
			
func AttachSpell():
	if AttachedSpell == 0:  #Is nil, remove item if it's there
		var childCount = get_node(spellAttachment).get_child_count();
		if childCount > 0:
			get_node(spellAttachment).get_child(0).queue_free();
	
	if AttachedSpell > 0:  #Is a valid item
		var refToItem = load(str("res://Prefabs/ItemsSpells/spell_", AttachedSpell, ".tscn"));
		var instance = refToItem.instantiate();
		get_node(spellAttachment).add_child(instance);

func AttachItem():
	if AttachedItem == 0:  #Is nil, remove item if it's there
		var childCount = get_node(itemAttachment).get_child_count();
		if childCount > 0:
			get_node(itemAttachment).get_child(0).queue_free();
	
	if AttachedItem > 0:  #Is a valid item
		var refToItem = load(str("res://Prefabs/ItemsSpells/item_", AttachedItem, ".tscn"));
		var instance = refToItem.instantiate();
		get_node(itemAttachment).add_child(instance);

func Damage(amt : int) -> void:
	print(str("Damaging player for ", amt));
	if damageDelay <= 0.0:
		DamageOverride(amt);

func DamageOverride(amt : int):
	GameDataHolder.Instance.data.MinHealth -= amt;
	PopupText.PrintText(str("-", amt, " HP"), get_tree(), Color.RED, global_position);
	targetColor = Color.RED;
	damageDelay = 5.0;
	UpdateUI();

func Heal(amt : int):
	
	var min = GameDataHolder.Instance.data.MinHealth;
	var max = GameDataHolder.Instance.data.MaxHealth;
	min += amt;
	if min > max:
		min = max;
	GameDataHolder.Instance.data.MinHealth = min;
	
	PopupText.PrintText(str("+", amt, " HP"), get_tree(), Color.GREEN, global_position);
	targetColor = Color.GREEN;
	PlayerUI.UpdateHUD = true;	

func UpdateUI():  
	#show health bar, gold, etc
	PlayerUI.UpdateHUD = true;
	
