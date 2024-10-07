extends CharacterBody3D

static var Health : int = 100;
var damageDelay : float = -1.0;
var GlobalUI : PackedScene;


func _enter_tree() -> void:
	UpdateUI();
	pass;

func _process(delta: float) -> void:
	pass;

func Damage(amt : int) -> void:
	if damageDelay <= 0.0:
		DamageOverride(amt);

func DamageOverride(amt : int):
	Health -= amt;
	UpdateUI();
	
func UpdateUI():  
	#show health bar, gold, etc
	pass;
	
