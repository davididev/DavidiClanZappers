class_name PlayerUI extends Control

var lastJumpStr = true;  #Jump/Interact button last set to jump

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var currentJumpStr : bool = true;
	if NPC.NPCsOverlapped.size() > 0:
		currentJumpStr = false;
	
	if currentJumpStr != lastJumpStr:  #UI Changed
		lastJumpStr = currentJumpStr;
		if lastJumpStr == true:  #Is Jumping
			get_node("BGButtons2/JumpButton/Label").text = "Jump";
		else:
			get_node("BGButtons2/JumpButton/Label").text = "Interact";

func UpdateOverlayText():
	pass;
