class_name PlayMusic extends Node3D

static var LastSong = "";
@export var AudioSource : NodePath;
static var Instance : PlayMusic;

var src : AudioStreamPlayer3D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	src = get_node(AudioSource);
	Instance = self;

static func PlaySong(s : String):
	if LastSong == s:  #Don't play the same song twice
		return;
	LastSong = s;
	var asset_name : String = str("res://Audio/Music/", LastSong);
	Instance.src.stream = load(asset_name);
	Instance.src.play();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = Avatar.PlayerPos;
	var aud = get_node("AudioStreamPlayer3D");
	if aud.playing == false:  #It ended, repeat it
		aud.play(); 
