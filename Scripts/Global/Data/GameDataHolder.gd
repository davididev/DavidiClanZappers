class_name GameDataHolder extends Node

static var Instance : GameDataHolder = GameDataHolder.new();
static var GameID : int = 1;
static var VarMeta : GameVarNames;

var data : GameData = null;

func GetGameData():
	if data == null:
		LoadFile();
	
	return data;

func LoadFile():
	var path = str("user://savegame", GameID, ".save");
	if ResourceLoader.exists(path):
		data = ResourceLoader.load(path);
	else:
		data = GameData.new();
	var path2 = str("res://Scripts/Local/VarNames/G", GameID, ".tres");
	if ResourceLoader.exists(path2):
		VarMeta  = ResourceLoader.load(path2);
	
func SaveFile():
	var path = str("user://savegame", GameID, ".save");
	var err : Error = ResourceSaver.save(data, path);
	if err:
		return false;
	else:
		return true;
