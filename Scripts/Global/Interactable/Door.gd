extends Node3D

@export var DialogueBase : DialogueGrid;
@export var SoundOnOpen : String;
@export var SceneToGoTo : String = "Game1/HannahYard";
@export var PositionToGoTo : Vector3;
@export var NPCRef : NodePath;
var targetY = 0.0;
var startingY = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startingY = global_rotation_degrees.y;
	targetY = startingY;
	var newDiaInstance = DialogueBase.DuplicateEntry();
	var args : Array[String] = ["", ""];
	args[0] = SceneToGoTo;
	args[1] = str(PositionToGoTo.x, ",", PositionToGoTo.y, ",", PositionToGoTo.z);
	newDiaInstance.grid[0][0].SetArguments(args);
	get_node(NPCRef).DialogueOnInteract = newDiaInstance;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_equal_approx(targetY, startingY):
		var rot = global_rotation_degrees;
		rot.y = move_toward(rot.y, targetY, -180.0 * delta);
		global_rotation_degrees = rot;
	


func _on_npc_pre_dialogue_event() -> void:
	targetY = startingY + 80.0;
	SoundFXPlayer.PlaySound(SoundOnOpen, get_tree(), global_position);
