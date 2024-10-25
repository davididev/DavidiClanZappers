class_name DialogueEntry extends Resource

@export var cmd : String;
@export var args : String;

#If the game uses an event programmed in script
func SetArguments(argList : Array[String]):
	var total = "";
	var firstArg = true;
	for arg in argList:
		arg = arg.replace("_", "&u;");
		print(str("Adding arg ", arg));
		if firstArg == false:  #If not first arg, add a comma argument seperator
			total = str(total, "_");
		total = str(total, arg);
		print(str("Total:  ", total));
		firstArg = false;
	
	args = total;

#Get the actual strings for runtime
func GetArguments() -> Array[String]:
	var temp = args.split("_");
	var temp2 : Array[String];
	for i in temp.size():
		#print(str("Adding ", i, ": ", temp[i]));
		temp2.append(temp[i].replace("&u;", "_"));
		
	return temp2;
