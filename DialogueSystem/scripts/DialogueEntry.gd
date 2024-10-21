class_name DialogueEntry extends Resource

@export var cmd : String;
@export var args : String;

#Get the actual strings for runtime
func GetArguments() -> Array[String]:
	var temp = args.split("_");
	var temp2 : Array[String];
	for i in temp.size():
		#print(str("Adding ", i, ": ", temp[i]));
		temp2.append(temp[i].replace("&u;", "_"));
		
	return temp2;
