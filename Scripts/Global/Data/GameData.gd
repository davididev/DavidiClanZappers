class_name GameData extends Resource

@export var MaxHealth : int = 100;
@export var MinHealth : int = 100;
@export var Str = 3;
@export var Mag = 1;
@export var IntVars = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
@export var BoolVars = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
@export var Items = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
@export var Spells = [0, 0, 0, 0, 0, 0, 0, 0];
@export var VolumeSound = 1.0;
@export var VolumeMusic = 1.0;
@export var VolumeGlobal = 1.0;
@export var ScenePath : String;

@export var savedNodes : Array[SerializedNode];

func Save(t : SceneTree):  #Mostly this is about saving the savedNodes
	var save_nodes = t.get_nodes_in_group("SerializedNode")
	print(str("Count of save nodes:", save_nodes.size()));
	savedNodes.clear();
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if node.has_method("SaveNode"):
			print("Saving node");
			var node_data = node.call("SaveNode");
			savedNodes.append(node_data);

func Load(t : SceneTree): #Mostly this is about loading the savedNodes
	#Load the persistent nodes
	for node in savedNodes:
		if t.root.get_node(node.path).has_method("LoadNode"):
			t.root.get_node(node.path).call("LoadNode", node);
		
	
	
