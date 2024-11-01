class_name PlayerUI extends Control

static var UpdateHUD = false;
var lastJumpStr = true;  #Jump/Interact button last set to jump

static var fadeTarget : Color;
const FADE_PER_SECOND = 2.0;

@export var pausePanels : Array[NodePath];
static var LastPausePanel = 0;
var paused = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.05).timeout;
	UpdateHUD = true;
	fadeTarget = Color(0.0, 0.0, 0.0, 0.0);
	SetPausePanel(-1);
	pass # Replace with function body.



func SetPausePanel(id : int):
	for i in range(0, pausePanels.size()):
		get_node(pausePanels[i]).visible = id == i;
		
	if id == 0:  #Opened inventory menu
		var invButtons = get_tree().get_nodes_in_group(&"InventoryButton");
		for but in invButtons:
			but.call("RedrawButton");

	paused = id > -1;

	if id > -1:
		LastPausePanel = id;
		#Now we set default button
		if id == 0:
			get_node("InventoryMenu/Spell Button 0").grab_focus();
		if id == 1:
			get_node("SettingsMenu/SaveButton").grab_focus();
		if id == 2:
			LastPausePanel = 0;
			get_node("ConfirmQuit Menu/CancelQuit").grab_focus();
	
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

	if Input.is_action_just_pressed("pause") && DialogueHandler.IsRunning == false:
		if paused:
			SetPausePanel(-1);
			Engine.time_scale = 1.0;
		else:
			SetPausePanel(LastPausePanel);
			Engine.time_scale = 1.0 / 360.0;
	
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
	if GameDataHolder.Instance.data != null:
		var h1 = GameDataHolder.Instance.data.MinHealth;
		var h2 = GameDataHolder.Instance.data.MaxHealth;
		var str = GameDataHolder.Instance.data.Str;
		var mag = GameDataHolder.Instance.data.Mag;
		rt.text = str("[color=red]Health: [b]", h1, "/",h2, "[/b][/color]\n[color=blue]Strength: [b]", str, "[/b] [/color]\n[color=green]Magic: [b]", mag, "[/b][/color]\n")
	
		print(str("VarName test 1: ", GameDataHolder.Instance.VarMeta.IntNames[0]));
	UpdateHUD = false;
	pass;


func _on_settings_button_pressed() -> void:
	SetPausePanel(1);


func _on_iventory_button_pressed() -> void:
	SetPausePanel(0);


func _on_save_button_pressed() -> void:
	var success = GameDataHolder.Instance.SaveFile(get_tree());
	if success:
		get_node("SettingsMenu/SaveButton").text = "Saved game!";
	else:
		get_node("SettingsMenu/SaveButton").text = "Failed; try again";
		
	await get_tree().create_timer(1.0, true, true, true).timeout;
	get_node("SettingsMenu/SaveButton").text = "Save and continue";


func _on_confirm_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Global/TitleScreen.tscn");	


func _on_quit_button_pressed() -> void:
	SetPausePanel(2);
