class_name PlayerPrefs extends Resource
static var Current : PlayerPrefs;
@export var LastGame = 1;
@export var VolumeMaster = 1.0;
@export var VolumeMusic = 1.0;
@export var VolumeSound = 1.0;

static func Load():
	if ResourceLoader.exists("user://prefs.res"):
		Current = ResourceLoader.load("user://prefs.res");
	else:
		Current = PlayerPrefs.new();
		Current.LastGame = 1;
		Current.VolumeMaster = 1.0;
		Current.VolumeMusic = 1.0;
		Current.VolumeSound = 1.0;
		Save();
	pass;

static func Save():
	ResourceSaver.save(Current, "user://prefs.res");
