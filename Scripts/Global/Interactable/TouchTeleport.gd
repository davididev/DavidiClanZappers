class_name TouchTeleport extends Area3D

@export var DialogueBase : DialogueGrid;
@export var SoundOnOpen : String;
@export var SceneToGoTo : String;
@export var PositionToGoTo : Vector3;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if SoundOnOpen != null:
			SoundFXPlayer.PlaySound(SoundOnOpen, get_tree(), global_position);
		var newDiaInstance = DialogueBase.duplicate(true);
		var args : Array[String] = ["", ""];
		args[0] = SceneToGoTo;
		args[1] = str(PositionToGoTo.x, ",", PositionToGoTo.y, ",", PositionToGoTo.z);
		newDiaInstance.grid[0][0].SetArguments(args);
		DialogueHandler.Instance.StartDialogue(newDiaInstance);
