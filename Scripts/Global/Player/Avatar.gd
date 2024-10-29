class_name Avatar extends CharacterBody3D

var damageDelay : float = -1.0;
@export var SksletonNode : NodePath;
var idLeft = 0;
var idRight = 0;

func _enter_tree() -> void:
	if GameDataHolder.Instance == null:
		GameDataHolder.Instance.LoadFile();
		
	var skel : Skeleton3D = get_node(SksletonNode);
	idLeft = skel.find_bone("ORG-hand.L");
	idRight = skel.find_bone("ORG-hand.R");
	
	UpdateUI();
	pass;

func _process(delta: float) -> void:
	var skel : Skeleton3D = get_node(SksletonNode);
	var pos1 = skel.get_bone_global_pose(idLeft).origin + skel.global_position;
	var pos2 = skel.get_bone_global_pose(idRight).origin + skel.global_position;
	#print(str(pos1, "   ", pos2));
	pass;

func Damage(amt : int) -> void:
	if damageDelay <= 0.0:
		DamageOverride(amt);

func DamageOverride(amt : int):
	GameDataHolder.Instance.MinHealth -= amt;
	UpdateUI();
	
func UpdateUI():  
	#show health bar, gold, etc
	PlayerUI.UpdateHUD = true;
	
