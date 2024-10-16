class_name DialogueGrid extends Resource
const WIDTH : int = 40;
const HEIGHT : int = 7;


@export var grid = [];

func Init() -> void:
	for i in WIDTH:
		grid.append([]);
		for j in HEIGHT:
			grid[i].append(null) # Set an empty starter value for each position

#Get entry from the serialized grid
func GetEntry(x : int, y : int):
	return grid[x][y];

#Add entry to the grid for serialization purposes
func AddEntryToGrid(x : int, y : int, commandStr: String, commandArgs : Array[String]):
	var entry = DialogueEntry.new();
	
	if commandStr == "":  #Is empty
		entry = null;
	else:
		entry.cmd = commandStr;
		var args : String = "";
		var first = true;
		for s in commandArgs:
			s = s.replace("_", "&u;");
			if first == true:
				args = str(s);
				first = false;
			else:
				args = str(args, "_", s);
		entry.args = args;
	grid[x][y] = entry;
