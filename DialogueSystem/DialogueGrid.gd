class_name DialogueGrid extends Resource
const WIDTH : int = 40;
const HEIGHT : int = 7;


@export var grid = [];

func Init() -> void:
	for i in WIDTH:
		grid.append([]);
		for j in HEIGHT:
			grid[i].append(null) # Set an empty starter value for each position
