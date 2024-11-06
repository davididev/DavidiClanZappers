class_name Node3DPool extends Node3D

static var Pool = {};
static var CurrentLocation : Node3D;

@export var starting_keys : Array[String];
@export var starting_prefabs : Array[PackedScene];
@export var starting_size : Array[int];

func _enter_tree() -> void:
	Pool.clear();
	CurrentLocation = self as Node3D;
	for i in range(0, starting_keys.size()):
		InitPoolItem(get_tree(), starting_keys[i], starting_prefabs[i], starting_size[i])

#Utility function to set a node active / inactive for the pool
static func SetActive(node : Node3D, status : bool):
	if status == true:
		node.visible = true;
		node.process_mode = ProcessMode.PROCESS_MODE_INHERIT;
	else:
		node.visible = false;
		node.process_mode = ProcessMode.PROCESS_MODE_PAUSABLE;


static func InitPoolItem(t : SceneTree, key : String, entry : PackedScene, size : int):
	if Pool.has(key):
		print(str("Key ", key, " already exists"));
		return;
	
	var listTemp : Array[Node3D];
	for i in range(0, size):
		var temp = entry.instantiate();
		CurrentLocation.add_child(temp);
		SetActive(temp, false);
		
		listTemp.append(temp);
		
	
	Pool[key] = listTemp;

static func GetInstance(key : String):
	if Pool.has(key):
		var list = Pool[key];
		for entry in list:
			if entry.visible == false:
				SetActive(entry, true);
				return entry;
		
	return null;
