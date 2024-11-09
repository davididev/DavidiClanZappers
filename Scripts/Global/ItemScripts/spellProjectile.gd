class_name SpellProjectile extends Node3D

#
#         *  It should be like this:
#                transform.basis.x 	right
#                -transform.basis.x 	left
#                transform.basis.y 	up
#                -transform.basis.y 	down
#                transform.basis.z 	forward
#                -transform.basis.z 	back 
#         */

@export var SpellDataID = 1;
@export var AttackPower = 3;
@export var LaunchSoundFX : String = "rpg/swingSword.mp3";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func UseSpell():
	var key = str("Spell", SpellDataID);
	var inst = Node3DPool.GetInstance(key);
	if inst != null:
		if LaunchSoundFX != "":
			SoundFXPlayer.PlaySound(LaunchSoundFX, get_tree(), global_position)
		inst.call("SetPower", AttackPower * GameDataHolder.Instance.data.Str);
		inst.global_position = global_position;
		inst.rotation = get_parent().global_rotation;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
