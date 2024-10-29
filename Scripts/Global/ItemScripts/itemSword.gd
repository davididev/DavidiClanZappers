extends Node3D

@export var refToOverlap : NodePath;
@export var swingSoundFX : String;
var swingTimer = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node(refToOverlap).set_process(false);
	pass # Replace with function body.

func UseItem():
	get_node(refToOverlap).set_process(true);
	if swingSoundFX != "":
		SoundFXPlayer.PlaySound(swingSoundFX, get_tree(), global_position);
	swingTimer = 0.6;
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if swingTimer > 0.0:
		swingTimer -= delta;
		if swingTimer <= 0.0:
			get_node(refToOverlap).set_process(false);
	pass
