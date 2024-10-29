class_name Avatar extends CharacterBody3D

var damageDelay : float = -1.0;
@export var itemAttachment : NodePath;
@export var spellAttachment : NodePath;
@export var npcAnimatorRef : NodePath;
static var AttachedItem = 0;
static var AttachedSpell = 0;

var idLeft = 0;
var idRight = 0;

func _enter_tree() -> void:
	if GameDataHolder.Instance == null:
		GameDataHolder.Instance.LoadFile();
	UpdateUI();
	#Assuming attached items / spells aren't nil, carry from previous maps
	AttachItem();
	AttachSpell();

func _process(delta: float) -> void:
	if AttachedItem > 0:
		#Prepare animations
		if Input.is_action_just_pressed("item"):
			get_node(npcAnimatorRef).PlayAttackAnim();
			get_node(itemAttachment).get_child(0).call("UseItem");

func AttachSpell():
	pass;

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
	if damageDelay <= 0.0:
		DamageOverride(amt);

func DamageOverride(amt : int):
	GameDataHolder.Instance.MinHealth -= amt;
	UpdateUI();
	
func UpdateUI():  
	#show health bar, gold, etc
	PlayerUI.UpdateHUD = true;
	
