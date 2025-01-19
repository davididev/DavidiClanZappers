extends Control
@export var panels : Array[NodePath];

const VOLUME_STEP = 0.05;
const VOLUME_MAX = 2.0;

const MAX_GAMES = 2;
var GameID = 1;
@onready var _bus1 := AudioServer.get_bus_index(&"Master")
@onready var _bus2 := AudioServer.get_bus_index(&"Sound")
@onready var _bus3 := AudioServer.get_bus_index(&"Music")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerPrefs.Load();
	UpdateSoundBus();
	Engine.time_scale = 1.0;
	BoilerPlate.First = true;
	SetPanel(0);
	PlayMusic.PlaySong("Title.mp3");
	GameID = PlayerPrefs.Current.LastGame;
	CycleQuests(0);
	
func CycleQuests(dir : int):
	GameID += dir;
	if GameID < 1:
		GameID = MAX_GAMES;
	if GameID > MAX_GAMES:
		GameID = 1;
	PlayerPrefs.Current.LastGame = GameID;
	PlayerPrefs.Save();
	var imagePath = str("res://Graphics/UI/Covers/Game", GameID, ".png");
	get_node("Panel SelectGame/Game Selecter Button/TextureRect").texture = load(imagePath);
	get_node("Panel PlayGame/TextureRect").texture = load(imagePath);
	
func SetPanel(id : int):
	for i in range(0, panels.size()):
		get_node(panels[i]).visible = id == i;
	
	if id == 0:
		get_node("Panel SelectGame/Prev Button").grab_focus()
	if id == 1:
		get_node("Panel PlayGame/Button Start").grab_focus();
		get_node("Panel PlayGame/Button Continue").visible = GameDataHolder.Instance.FileExists();

	if id == 2:
		get_node("Panel Settings/Button_LowerMaster").grab_focus();
		UpdateVolumeUI();
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_selecter_button_pressed() -> void:
	GameDataHolder.Instance.GameID = GameID;
	SetPanel(1);


func _on_button_start_pressed() -> void:
	GameDataHolder.Instance.NewFile();
	
	NewOrContinueFile();	
	
func NewOrContinueFile():
	await get_tree().create_timer(0.1).timeout;
	LoadingUI.SceneToLoad = GameDataHolder.Instance.data.ScenePath;
	get_tree().change_scene_to_file("res://Scenes/Global/Loading.tscn");	


func _on_button_continue_pressed() -> void:
	GameDataHolder.Instance.LoadFile();
	NewOrContinueFile();	


func _on_quit_button_pressed() -> void:
	get_tree().quit();


func _on_prev_button_pressed() -> void:
	CycleQuests(-1);


func _on_next_button_pressed() -> void:
	CycleQuests(1);


func _on_button_cancel_pressed() -> void:
	SetPanel(0);


func _on_settings_button_pressed() -> void:
	SetPanel(2);


func _on_button_save_player_prefs_pressed() -> void:
	PlayerPrefs.Save();
	SetPanel(0);

func UpdateSoundBus():
	AudioServer.set_bus_volume_db(_bus1, linear_to_db(PlayerPrefs.Current.VolumeMaster));
	AudioServer.set_bus_volume_db(_bus2, linear_to_db(PlayerPrefs.Current.VolumeSound));
	AudioServer.set_bus_volume_db(_bus3, linear_to_db(PlayerPrefs.Current.VolumeMusic));

func UpdateVolumeUI():
	var v1 = ceil(PlayerPrefs.Current.VolumeMaster * 100.0);
	var v2 = ceil(PlayerPrefs.Current.VolumeSound * 100.0);
	var v3 = ceil(PlayerPrefs.Current.VolumeMusic * 100.0);
	get_node("Panel Settings/VolumeMasterLabel").text = str("[center][font_size=36]Volume Master[/font_size]\n", v1, "%[/center]");
	get_node("Panel Settings/VolumeSoundLabel").text = str("[center][font_size=36]Volume Sound[/font_size]\n", v2, "%[/center]");
	get_node("Panel Settings/VolumeMusicLabel").text = str("[center][font_size=36]Volume Music[/font_size]\n", v3, "%[/center]");
	UpdateSoundBus();

func _on_button_lower_master_pressed() -> void:
	PlayerPrefs.Current.VolumeMaster -= VOLUME_STEP;
	if PlayerPrefs.Current.VolumeMaster < 0.0:
		PlayerPrefs.Current.VolumeMaster = 0.0;
	UpdateVolumeUI();


func _on_button_lower_sound_pressed() -> void:
	PlayerPrefs.Current.VolumeSound -= VOLUME_STEP;
	if PlayerPrefs.Current.VolumeSound < 0.0:
		PlayerPrefs.Current.VolumeSound = 0.0;
	UpdateVolumeUI();


func _on_button_lower_music_pressed() -> void:
	PlayerPrefs.Current.VolumeMusic -= VOLUME_STEP;
	if PlayerPrefs.Current.VolumeMusic < 0.0:
		PlayerPrefs.Current.VolumeMusic = 0.0;
	UpdateVolumeUI();


func _on_button_raise_master_pressed() -> void:
	PlayerPrefs.Current.VolumeMaster += VOLUME_STEP;
	if PlayerPrefs.Current.VolumeMaster > VOLUME_MAX:
		PlayerPrefs.Current.VolumeMaster = VOLUME_MAX;
	UpdateVolumeUI();


func _on_button_raise_sound_pressed() -> void:
	PlayerPrefs.Current.VolumeSound += VOLUME_STEP;
	if PlayerPrefs.Current.VolumeSound > VOLUME_MAX:
		PlayerPrefs.Current.VolumeSound = VOLUME_MAX;
	UpdateVolumeUI();
	
	


func _on_button_raise_music_pressed() -> void:
	PlayerPrefs.Current.VolumeMusic += VOLUME_STEP;
	if PlayerPrefs.Current.VolumeMusic > VOLUME_MAX:
		PlayerPrefs.Current.VolumeMusic = VOLUME_MAX;
	UpdateVolumeUI();


func _on_button_cancel_settings_pressed() -> void:
	PlayerPrefs.Load();  #Load previous state
	SetPanel(0);
