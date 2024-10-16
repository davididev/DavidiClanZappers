class_name DialogueArgsUtility extends Node

static func FilterRichText(s : String):
	if s.contains("\\c"):
		s = s.replace("\\c[0]", "[/color]");  #Close color tag
		s = s.replace("\\c[1]", "[color=#ffff00]");  #Color 1- yellow
		s = s.replace("\\c[2]", "[color=#00ff00]"); #Color 2- green
		s = s.replace("\\c[3]", "[color=#ff0000]"); #Color 3- red
		s = s.replace("\\c[4]", "[color=#aaaaaa]"); #Color 4- grey
	return s;

static func FilterDialogueVariables(s : String):
	if s.contains("%"):
		for vkey  in DialogueHandler.variables.keys():
			var vvalue = DialogueHandler.variables[vkey];
			s = s.replace(vkey, vvalue);
	return s;

static func ConvertStringToFloat(s : String):
	return s.to_float();

static func SetNextNodeFromStr(s : String):
	var myCoords = s.split(",");
	DialogueHandler.CurrentX = myCoords[0].to_int();
	DialogueHandler.CurrentY = myCoords[1].to_int();
