class_name GateUnlockDialogue extends Node3D

signal Open();
@export var Visible_Refs : Array[NodePath];
@export var Collision_Refs  : Array[NodePath];
@export var Sound_On_Open = "rpg/doorClose_3.ogg";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_open() -> void:
	for tempNode in Visible_Refs:
		get_node(tempNode).visible = false;
	for tempNode in Collision_Refs:
		get_node(tempNode).call_deferred("set_disabled", true);

	SoundFXPlayer.PlaySound(Sound_On_Open, get_tree(), global_position);
