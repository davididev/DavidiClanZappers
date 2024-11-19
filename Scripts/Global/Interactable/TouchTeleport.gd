class_name TouchTeleport extends Area3D

@export var DialogueBase : DialogueGrid;
@export var SoundOnOpen : String;
@export var SceneToGoTo : String;
@export var PositionToGoTo : Vector3;
var awaitTimer = 0.05;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	awaitTimer = 0.05;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if awaitTimer > 0.0:
		awaitTimer -= delta;
	pass


func _on_body_entered(body: Node3D) -> void:
	if awaitTimer > 0.0:
		return;
	if body.is_in_group("Player"):
		if SoundOnOpen != "":
			SoundFXPlayer.PlaySound(SoundOnOpen, get_tree(), global_position);
		var newDiaInstance = DialogueBase.DuplicateEntry();
		var args : Array[String] = ["", ""];
		args[0] = SceneToGoTo;
		args[1] = str(PositionToGoTo.x, ",", PositionToGoTo.y, ",", PositionToGoTo.z);
		newDiaInstance.grid[0][0].SetArguments(args);
		DialogueHandler.Instance.StartDialogue(newDiaInstance);
