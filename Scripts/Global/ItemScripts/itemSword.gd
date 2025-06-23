extends Node3D

@export var refToOverlap : NodePath;
@export var swingSoundFX : String;
@export var hitSoundFX : String;
@export var BaseAttackPower = 4;
@export var Colliders : Array[NodePath];
var swingTimer = 0.0;

signal OnDamage(Amount : int);  #Enemies will need to use this

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node(refToOverlap).set_process(false);
	pass # Replace with function body.

func UseItem():
	if swingTimer <= 0.0:
		if swingSoundFX != "":
			SoundFXPlayer.PlaySound(swingSoundFX, get_tree(), global_position);
		swingTimer = 0.6;
		DisableColliders(false);
		pass;
	
func DisableColliders(stat : bool):
	for np in Colliders:
		var cs = get_node(np) as CollisionShape3D;
		cs.call_deferred("set_disabled", stat);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if swingTimer > 0.0:
		get_node(refToOverlap).monitoring = true;  #Don't monitor unless it's running
		swingTimer -= delta;
	else:
		get_node(refToOverlap).monitoring = false;
		DisableColliders(true);


func _on_area_3d_body_entered(body: Node3D) -> void:
	if swingTimer > 0.0:  #Only if swing animation is playing
		var dmg = BaseAttackPower * GameDataHolder.Instance.data.Str;
		body.emit_signal("OnDamage", dmg);
		if body.has_signal("OnDamage"):
			SoundFXPlayer.PlaySound(hitSoundFX, get_tree(), global_position);
