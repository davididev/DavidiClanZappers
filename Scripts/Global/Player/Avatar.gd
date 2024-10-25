class_name Avatar extends CharacterBody3D

var damageDelay : float = -1.0;


func _enter_tree() -> void:
	if GameDataHolder.Instance == null:
		GameDataHolder.Instance.LoadFile();
	UpdateUI();
	pass;

func _process(delta: float) -> void:
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
	
