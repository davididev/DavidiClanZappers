class_name PlayerUI extends Control

static var UpdateHUD = false;
var lastJumpStr = true;  #Jump/Interact button last set to jump

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.05).timeout;
	UpdateHUD = true;
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

	if UpdateHUD:
		UpdatePlayerHUD();
		
func UpdatePlayerHUD():  #TODO: Update HUD
	var rt = get_node("HUD");
	var h1 = GameDataHolder.Instance.data.MinHealth;
	var h2 = GameDataHolder.Instance.data.MaxHealth;
	var str = GameDataHolder.Instance.data.Str;
	var mag = GameDataHolder.Instance.data.Mag;
	rt.text = str("[color=red]Health: [b]", h1, "/",h2, "[/b][/color]\n[color=blue]Strength: [b]", str, "[/b] [/color]\n[color=green]Magic: [b]", mag, "[/b][/color]\n")
	
	print(str("VarName test 1: ", GameDataHolder.Instance.VarMeta.IntNames[0]));
	UpdateHUD = false;
	pass;
