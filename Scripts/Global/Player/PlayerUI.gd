class_name PlayerUI extends Control
const VOLUME_STEP = 0.05;
const VOLUME_MAX = 2.0;
static var UpdateHUD = false;
var lastJumpStr = true;  #Jump/Interact button last set to jump

var gameOverScale = 0.0;

static var fadeTarget : Color;
const FADE_PER_SECOND = 2.0;

@export var pausePanels : Array[NodePath];
static var LastPausePanel = 0;
var paused = false;

@onready var _bus1 := AudioServer.get_bus_index(&"Master")
@onready var _bus2 := AudioServer.get_bus_index(&"Sound")
@onready var _bus3 := AudioServer.get_bus_index(&"Music")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if minTimerMagic < 0.0:
		minTimerMagic = 0.0;
	if maxTimerMagic < 0.0:
		maxTimerMagic = 0.0;
	await get_tree().create_timer(0.05).timeout;
	UpdateHUD = true;
	paused = false;
	fadeTarget = Color(0.0, 0.0, 0.0, 0.0);
	SetPausePanel(-1);
	UpdateSoundBus();
	InitSpellPool();



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
	
static var SpellReady = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var currentJumpStr : bool = true;
	if NPC.NPCsOverlapped.size() > 0:
		currentJumpStr = false;
	
	if Avatar.AttachedSpell > 0:
		minTimerMagic += delta * GameDataHolder.Instance.data.Mag;
		if minTimerMagic > maxTimerMagic:
			SpellReady = true;
			minTimerMagic = maxTimerMagic;
		else:
			SpellReady = false;
		get_node("SpellBar").value = minTimerMagic / maxTimerMagic * 100.0;
	
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
			SetPausePanel(0);
			Engine.time_scale = 1.0 / 360.0;
	
	if currentJumpStr != lastJumpStr:  #UI Changed
		lastJumpStr = currentJumpStr;
		if lastJumpStr == true:  #Is Jumping
			get_node("BGButtons2/JumpButton/Label").text = "Jump";
		else:
			get_node("BGButtons2/JumpButton/Label").text = "Interact";
	if is_equal_approx(gameOverScale, 0.0) && GameDataHolder.Instance.data.MinHealth <= 0:
		gameOverScale = 0.01;

	if gameOverScale > 0.0 && gameOverScale < 1.0:
		gameOverScale = move_toward(gameOverScale, 1.0, 2.0 * delta);
		get_node("GameOverTeture").scale = Vector2(1.0, gameOverScale);
		if is_equal_approx(gameOverScale, 1.0):
			await get_tree().create_timer(2.0, true, true, true).timeout;
			get_tree().change_scene_to_file("res://Scenes/Global/TitleScreen.tscn");	

	if UpdateHUD:
		UpdatePlayerHUD();

static var maxTimerMagic = 0.0;
static var minTimerMagic = 0.0;
static var SpellPrefab : PackedScene;

func InitSpellPool():
	if SpellPrefab != null:
		var key = str("Spell", Avatar.AttachedSpell);
		Node3DPool.InitPoolItem(get_tree(), key, SpellPrefab, 5);

func UpdatePlayerHUD():  #TODO: Update HUD
	var rt = get_node("HUD");
	if GameDataHolder.Instance.data != null:
		var h1 = GameDataHolder.Instance.data.MinHealth;
		var h2 = GameDataHolder.Instance.data.MaxHealth;
		var str = GameDataHolder.Instance.data.Str;
		var mag = GameDataHolder.Instance.data.Mag;
		rt.text = str("[color=red]Health: [b]", h1, "/",h2, "[/b][/color]\n[color=blue]Strength: [b]", str, "[/b] [/color]\n[color=green]Magic: [b]", mag, "[/b][/color]\n")
		get_node("Gold").text = str("[right]Gold: [color=yellow]", GameDataHolder.Instance.data.Gold);
		print(str("VarName test 1: ", GameDataHolder.Instance.VarMeta.IntNames[0]));
	get_node("SpellBar").visible = Avatar.AttachedSpell > 0;
	if Avatar.AttachedSpell > 0:
		get_node("SpellBar/TextureRect").texture = load(str("res://Graphics/UI/Inventory/Spell", Avatar.AttachedSpell, ".png"));
		var meta : SpellMetaData = load(str("res://Scripts/Global/SpellScripts/Spell", Avatar.AttachedSpell, ".tres"));
		maxTimerMagic = meta.ChargeTime;
		SpellPrefab = meta.FirePrefab;
		InitSpellPool();
	UpdateHUD = false;
	pass;


func _on_settings_button_pressed() -> void:
	SetPausePanel(1);


func _on_iventory_button_pressed() -> void:
	SetPausePanel(0);


func _on_save_button_pressed() -> void:
	var success = GameDataHolder.Instance.SaveFile(get_tree());
	if success:
		SoundFXPlayer.PlaySound("interface/confirmation_001.ogg", get_tree(), Avatar.PlayerPos);
		get_node("SettingsMenu/SaveButton").text = "Saved game!";
	else:
		SoundFXPlayer.PlaySound("interface/error_003.ogg", get_tree(), Avatar.PlayerPos);
		get_node("SettingsMenu/SaveButton").text = "Failed; try again";
		
	await get_tree().create_timer(1.0, true, true, true).timeout;
	get_node("SettingsMenu/SaveButton").text = "Save and continue";


func _on_confirm_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Global/TitleScreen.tscn");	


func _on_quit_button_pressed() -> void:
	SetPausePanel(2);

func UpdateSoundBus():
	AudioServer.set_bus_volume_db(_bus1, linear_to_db(GameDataHolder.Instance.data.VolumeGlobal));
	AudioServer.set_bus_volume_db(_bus2, linear_to_db(GameDataHolder.Instance.data.VolumeSound));
	AudioServer.set_bus_volume_db(_bus3, linear_to_db(GameDataHolder.Instance.data.VolumeMusic));

func RefreshVolumeText():
	var v1 = ceil(GameDataHolder.Instance.data.VolumeGlobal * 100.0);
	var v2 = ceil(GameDataHolder.Instance.data.VolumeSound * 100.0);
	var v3 = ceil(GameDataHolder.Instance.data.VolumeMusic * 100.0);
	get_node("SettingsMenu/VolumeMasterLabel").text = str("[center][font_size=36]Volume Master[/font_size]\n", v1, "%[/center]");
	get_node("SettingsMenu/VolumeSoundLabel").text = str("[center][font_size=36]Volume Sound[/font_size]\n", v2, "%[/center]");
	get_node("SettingsMenu/VolumeMusicLabel").text = str("[center][font_size=36]Volume Music[/font_size]\n", v3, "%[/center]");
	UpdateSoundBus();

func _on_volume_master_down_pressed() -> void:
	var v = GameDataHolder.Instance.data.VolumeGlobal;
	v -= VOLUME_STEP;
	if v < 0.0:
		v = 0.0;
	GameDataHolder.Instance.data.VolumeGlobal = v;
	RefreshVolumeText();


func _on_volume_master_up_pressed() -> void:
	var v = GameDataHolder.Instance.data.VolumeGlobal;
	v += VOLUME_STEP;
	if v > VOLUME_MAX:
		v = VOLUME_MAX;
	GameDataHolder.Instance.data.VolumeGlobal = v;
	RefreshVolumeText();


func _on_volume_sound_down_pressed() -> void:
	var v = GameDataHolder.Instance.data.VolumeSound;
	v -= VOLUME_STEP;
	if v < 0.0:
		v = 0.0;
	GameDataHolder.Instance.data.VolumeSound = v;
	RefreshVolumeText();


func _on_volume_sound_up_pressed() -> void:
	var v = GameDataHolder.Instance.data.VolumeSound;
	v += VOLUME_STEP;
	if v > VOLUME_MAX:
		v = VOLUME_MAX;
	GameDataHolder.Instance.data.VolumeSound = v;
	RefreshVolumeText();


func _on_volume_music_down_pressed() -> void:
	var v = GameDataHolder.Instance.data.VolumeMusic;
	v -= VOLUME_STEP;
	if v < 0.0:
		v = 0.0;
	GameDataHolder.Instance.data.VolumeMusic = v;
	RefreshVolumeText();


func _on_volume_music_up_pressed() -> void:
	var v = GameDataHolder.Instance.data.VolumeMusic;
	v += VOLUME_STEP;
	if v > VOLUME_MAX:
		v = VOLUME_MAX;
	GameDataHolder.Instance.data.VolumeMusic = v;
	RefreshVolumeText();
