class_name GameDataHolder extends Node

static var Instance : GameDataHolder = GameDataHolder.new();
static var GameID : int = 0;

var data : GameData;

func GetGameData():
	if data == null:
		LoadFile();
	
	return data;

func LoadFile():
	var path = str("user://savegame", GameID, ".save");
	if ResourceLoader.exists(path):
		data = ResourceLoader.load(path);
	
func SaveFile():
	var path = str("user://savegame", GameID, ".save");
	var err : Error = ResourceSaver.save(data, path);
	if err:
		return false;
	else:
		return true;
