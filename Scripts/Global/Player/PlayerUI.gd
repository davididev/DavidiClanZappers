class_name PlayerUI extends Control

static var UpdateHUD = false;
var lastJumpStr = true;  #Jump/Interact button last set to jump

static var fadeTarget : Color;
const FADE_PER_SECOND = 2.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.05).timeout;
	UpdateHUD = true;
	fadeTarget = Color(0.0, 0.0, 0.0, 0.0);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var currentJumpStr : bool = true;
	if NPC.NPCsOverlapped.size() > 0:
		currentJumpStr = false;
	
	var rect : ColorRect = get_node("Fade");
	if rect.color != fadeTarget:
		var c = rect.color;
		c.r = move_toward(c.r, fadeTarget.r, FADE_PER_SECOND * delta);
		c.g = move_toward(c.g, fadeTarget.g, FADE_PER_SECOND * delta);
		c.b = move_toward(c.b, fadeTarget.b, FADE_PER_SECOND * delta);
		c.a = move_toward(c.a, fadeTarget.a, FADE_PER_SECOND * delta);
		rect.color = c;
	
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
