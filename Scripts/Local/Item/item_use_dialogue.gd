extends Node3D

@export var myEntry : DialogueGrid;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func UseItem():
	DialogueHandler.Instance.StartDialogue(myEntry);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
