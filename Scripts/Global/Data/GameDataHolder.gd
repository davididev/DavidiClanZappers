class_name GameDataHolder extends Node

static var Instance : GameDataHolder = GameDataHolder.new();
static var GameID : int = 3;
static var VarMeta : GameVarNames;

var data : GameData = null;

func FileExists():
	var path = str("user://savegame", GameID, ".res");
	return ResourceLoader.exists(path);

func GetGameData():
	if data == null:
		LoadFile();
	
	return data;

func NewFile():
	LoadFile(true);

func LoadFile(isNew : bool = false):
	var path = str("user://savegame", GameID, ".res");
	if ResourceLoader.exists(path) && isNew == false:
		data = ResourceLoader.load(path);
	else:
		data = GameData.new();
	var path2 = str("res://Scripts/Local/VarNames/G", GameID, ".tres");
	if ResourceLoader.exists(path2):
		VarMeta  = ResourceLoader.load(path2);
		if isNew:
			data.MaxHealth = VarMeta.StartingHealth;
			data.MinHealth = VarMeta.StartingHealth;
			data.Str = VarMeta.StartingStr;
			data.Mag = VarMeta.StartingMag;
			data.ScenePath = VarMeta.StartingScene;
			data.VolumeGlobal = PlayerPrefs.Current.VolumeMaster;
			data.VolumeMusic = PlayerPrefs.Current.VolumeMusic;
			data.VolumeSound = PlayerPrefs.Current.VolumeSound;
			
			
func SaveFile(t : SceneTree):
	var path = str("user://savegame", GameID, ".res");
	data.Save(t);
	var err : Error = ResourceSaver.save(data, path);
	if err:
		print(str, "Error saving: ", err);
		return false;
	else:
		return true;
