class_name NPC_ItemPickup extends Node3D

signal Hide();

@export var SpellID = 0;
@export var ItemID = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#If you've already collected
	if ItemID > 0:
		if DialogueArgsUtility.GetItemCount(ItemID) > 0:
			queue_free();
	if SpellID > 0:
		if DialogueArgsUtility.GetSpellCount(SpellID) > 0:
			queue_free();
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hide() -> void:
	queue_free();
