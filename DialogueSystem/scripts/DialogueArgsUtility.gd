class_name DialogueArgsUtility extends Node

static func GetItemCount(id : int):
	var count = 0;
	for i in range(0, 12):
		if GameDataHolder.Instance.data.Items[i] == id:
			count += 1;
	return float(count);
	
static func GetSpellCount(id : int):
	var count = 0;
	for i in range(0, 8):
		if GameDataHolder.Instance.data.Spells[i] == id:
			count += 1;
	return float(count);

static func FilterRichText(s : String):
	if s.contains("\\c"):
		s = s.replace("\\c[0]", "[/color]");  #Close color tag
		s = s.replace("\\c[1]", "[color=#ffff00]");  #Color 1- yellow
		s = s.replace("\\c[2]", "[color=#00ff00]"); #Color 2- green
		s = s.replace("\\c[3]", "[color=#ff0000]"); #Color 3- red
		s = s.replace("\\c[4]", "[color=#aaaaaa]"); #Color 4- grey
		
	s = s.replace("\\n", "\n")
	return s;

static func ConvertStringToVector3(s : String):
	var vec : Vector3;
	var coords = s.split(",");
	vec.x = (coords[0].to_float());
	vec.y = (coords[1].to_float());
	vec.z = (coords[2].to_float());
	return vec;

static func FilterDialogueVariables(s : String):
	if s.contains("%"):
		for vkey in DialogueHandler.variables.keys():
			#if vkey == s:  #Only copy value if the key is equal to the variable we're putting in
			var vvalue = DialogueHandler.variables[vkey];
			s = s.replace(vkey, str(vvalue));
	return s;

static func ConvertStringToFloat(s : String):
	s = DialogueArgsUtility.FilterDialogueVariables(s);
	return s.to_float();
	
static func ConvertStringToInt(s : String):
	s = DialogueArgsUtility.FilterDialogueVariables(s);
	return s.to_int();

static func SetNextNodeFromStr(s : String):
	var myCoords = s.split(",");
	DialogueHandler.CurrentX = myCoords[0].to_int();
	DialogueHandler.CurrentY = myCoords[1].to_int();
	DialogueHandler.Instance.ObtainDialogue();
