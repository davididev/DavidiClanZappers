class_name DialogueHandler extends TextureRect

@export var HeaderText : NodePath;
@export var BodyText : NodePath;
@export var ChoiceButtons : Array[NodePath];
@export var FlashImage : NodePath;

static var Instance : DialogueHandler;
var dialogueThread : DialogueGrid;
static var IsRunning = false;

static var CurrentX : int = 0;
static var CurrentY : int = 0;
static var variables : Dictionary;
static var Selected_Choice = -1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IsRunning = false;
	Instance = self;

static func SetVariable(vname : String, vvalue : float):
	#if variables.find_key(vname) == null:  #Hasn't added variable yet
	#	print(str("Key ", vname, " does not exist yet."));
	#	vvalue = variables.get_or_add(vname, vvalue);
	#else:
	#	print(str("Key ", vname, " exists.  Setting to ", vvalue))
	#	variables[vname] = vvalue;
	variables[vname] = vvalue;

static func GetVariable(vname : String):
	
	if variables.has(vname) == false:  #Hasn't added variable yet
		#print(str("Get Var ", vname, "; Variable doesn't exist yet"));
		return 0.0;
	else:
		#print(str("Get Var ", vname, "; Variable exists; value is", variables[vname]));
		return variables[vname];

func InitDialogueVars():
	var varNames = GameDataHolder.Instance.VarMeta.IntNames;
	for i in range(0, varNames.size()):
		SetVariable(varNames[i], GameDataHolder.Instance.data.IntVars[i]);
	
	SetVariable("%gold", GameDataHolder.Instance.data.Gold);
	SetVariable("%mag", GameDataHolder.Instance.data.Mag);
	SetVariable("%str", GameDataHolder.Instance.data.Str);

func CloseDialogueVars():
	var varNames = GameDataHolder.Instance.VarMeta.IntNames;
	for i in range(0, varNames.size()):
		GameDataHolder.Instance.data.IntVars[i] = GetVariable(varNames[i]);
	
	GameDataHolder.Instance.data.Gold = GetVariable("%gold");	
	GameDataHolder.Instance.data.Mag = GetVariable("%mag");
	GameDataHolder.Instance.data.Str = GetVariable("%str");
	PlayerUI.UpdateHUD = true;

func StartDialogue(runThis : DialogueGrid):
	CurrentX = 0;
	CurrentY = 0;
	IsRunning = true;
	dialogueThread = runThis;
	InitDialogueVars();
	ObtainDialogue();


#Using CurrentX and CurrentY, get the DialogueEntry node and start up the function
func ObtainDialogue():
	#Reset the dialogue box before the event
	visible = false;
	for c in ChoiceButtons:
		get_node(c).visible = false;
	var currentNode : DialogueEntry = dialogueThread.GetEntry(CurrentX, CurrentY);
	if currentNode == null:
		EndDialogue();
	else:
		var command = currentNode.cmd;
		var args = currentNode.GetArguments();
		if command == "str":
			StreamDialogueBox(args);
		if command == "choice":
			StreamChoiceBox(args);
		if command == "end":
			EndDialogue();
		if command == "var":
			StreamModifyVariables(args);
		if command == "tel":
			StreamTeleportNPC(args);
		if command == "wait":
			StreamWait(args);
		if command == "sce":
			SteamTeleport(args);
		if command == "msg":
			StreamSendMessage(args);
		if command == "ais":
			StreamAddItem(args);
		if command == "cis":
			StreamCountItem(args);
		if command == "ifthen":
			StreamIfThen(args);
func StreamIfThen(args : Array[String]):
	var variableName = args[0];
	var operatorStr = args[1];
	var valueStr = args[2];
	var nextNodeIfTrue = args[3];
	var nextNodeIfFalse = args[4];
	
	var valueLeft = DialogueArgsUtility.FilterDialogueVariables(variableName).to_float();
	var valueRight = DialogueArgsUtility.FilterDialogueVariables(valueStr).to_float();
	
	
	var isTrue = false;
	if operatorStr == "==":
		if is_equal_approx(valueLeft, valueRight):
			isTrue = true;
	if operatorStr == "!=":
		if is_equal_approx(valueLeft, valueRight) == false:
			isTrue = true;
	if operatorStr == ">":
		if valueLeft > valueRight:
			isTrue = true;
	if operatorStr == ">=":
		if valueLeft >= valueRight:
			isTrue = true;
	if operatorStr == "<":
		if valueLeft < valueRight:
			isTrue = true;
	if operatorStr == "<=":
		if valueLeft <= valueRight:
			isTrue = true;
	
	if isTrue:
		DialogueArgsUtility.SetNextNodeFromStr(nextNodeIfTrue);
	else:
		DialogueArgsUtility.SetNextNodeFromStr(nextNodeIfFalse);

func StreamCountItem(args : Array[String]):
	var itemOrSpell = DialogueArgsUtility.ConvertStringToInt(args[0]);
	var isItem = true;
	if args[1] == "false":
		isItem = false;
	var varNameToSet = args[2];
	var nextNodeStr = args[3];
	var count = 0;
	if isItem:
		count = DialogueArgsUtility.GetItemCount(itemOrSpell);
	if isItem == false:
		count = DialogueArgsUtility.GetSpellCount(itemOrSpell);
	
	
	SetVariable(varNameToSet, count);
	
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);
	

func StreamAddItem(args : Array[String]):
	var itemSpellID = DialogueArgsUtility.ConvertStringToInt(args[0]);
	var isItem = true;
	if args[1] == "false":
		isItem = false;
	var nextNodeSuccess = args[2];
	var nextNodeFailure = args[3];
	
	var success = false;
	if isItem:
		for i in range(0, 12):
			if GameDataHolder.Instance.data.Items[i] == 0:
				success = true;
				GameDataHolder.Instance.data.Items[i] = itemSpellID;
				break;
	if isItem == false:
		for i in range(0, 8):
			if GameDataHolder.Instance.data.Spells[i] == 0:
				success = true;
				GameDataHolder.Instance.data.Spells[i] = itemSpellID;
				break;
	
	if success:
		DialogueArgsUtility.SetNextNodeFromStr(nextNodeSuccess);
	else:
		DialogueArgsUtility.SetNextNodeFromStr(nextNodeFailure);
	
func StreamSendMessage(args : Array[String]):
	var actorName = args[0];
	var signalName = args[1];
	var nextNodeStr = args[2];
	NPC.npcList[actorName].SendSignal(signalName);
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);

func SteamTeleport(args : Array[String]):
	PlayerUI.fadeTarget = Color(0.0, 0.0, 0.0, 1.0);
	await get_tree().create_timer(0.5).timeout;
	LoadingUI.SceneToLoad = args[0];
	BoilerPlate.StartingPosition = DialogueArgsUtility.ConvertStringToVector3(args[1]);
	get_tree().change_scene_to_file("res://Scenes/Global/Loading.tscn");
	DialogueHandler.IsRunning = false;
	
func StreamWait(args : Array[String]):
	var waitTime = args[0].to_float();
	var waitForMovement = true;
	if args[1] == "false":
		waitForMovement = false;
	var nextNodeStr = args[2];
	
	await get_tree().create_timer(waitTime).timeout;
	if waitForMovement == true:
		print("TODO: Wait for movement");
	
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);
	
	
func StreamTeleportNPC(args : Array[String]):
	var npcName = args[0];
	var positionStr = args[1].split(",");
	var nextNodeStr = args[2];
	var pos : Vector3 = Vector3(positionStr[0].to_float(), positionStr[1].to_float(), positionStr[2].to_float());
	NPC.npcList[npcName].TeleportActor(pos);
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);
	

func StreamModifyVariables(args : Array[String]):
	var varName = args[0];
	var finalValue = GetVariable(varName);
	
	var operator = args[1];
	var firstValue = DialogueArgsUtility.FilterDialogueVariables(args[2]).to_float();
	
	#Set var does this automatically
	if operator == "=":  #Add var
		finalValue = firstValue;
	if operator == "+=":  #Add var
		finalValue += firstValue;
	if operator == "-=":  #Subtract var
		finalValue -= firstValue;
	if operator == "*=":  #Multiply var
		finalValue *= firstValue;
	if operator == "/=":  #Divide var
		finalValue /= firstValue;
	if operator == "+":  #Add var
		finalValue += firstValue;
	if operator == "-":  #Subtract var
		finalValue -= firstValue;
	if operator == "*":  #Multiply var
		finalValue *= firstValue;
	if operator == "/":  #Divide var
		finalValue /= firstValue;
	
	SetVariable(varName, finalValue);
	DialogueArgsUtility.SetNextNodeFromStr(args[3]);

func StreamDialogueBox(args : Array[String]):
	
	var charName = args[0];
	visible = true;
	get_node(HeaderText).text = str("[center]", charName, "[/center]");
	get_node(BodyText).text = "";
	var text : String = args[1];
	text = DialogueArgsUtility.FilterRichText(text);
	text = DialogueArgsUtility.FilterDialogueVariables(text);
	var charsPerSecond = DialogueArgsUtility.ConvertStringToFloat(args[2]);
	var soundFXDirectory = args[3];
	
	var asset_name : String = str("res://DialogueSystem/audio/", soundFXDirectory, ".mp3");
	get_node("AudioStreamPlayer3D").stream = load(asset_name);
	#get_node("AudioStreamPlayer3D").play();
	textboxsoundrunning = true;
	
	var nextNode = args[4];
	
	var currentCharID = 1;
	while currentCharID < text.length():
		if currentCharID > text.length():
			currentCharID = text.length();
			
		currentCharID += 1;
		if currentCharID < text.length():  #Don't attempt this loop of closing tags unless we're at the end
			var tagFound = true;
			while tagFound == true:  #Putting this in a loop in case we have multiple tags next to each other
				if currentCharID >= text.length(): #We're at the end of the string, break the loop
					tagFound = false;
				if currentCharID < text.length():
					if text[currentCharID] == "[":	  #Keep the loop going, we're still processing tags
						currentCharID = text.find("]", currentCharID) + 1;
						if currentCharID > text.length(): #We're at the end of the string, break the loop
							currentCharID = text.length() - 1;
							tagFound = false;
					else:  #The next char is not a [, break the loop
						tagFound = false;
		if currentCharID > text.length():
			currentCharID = text.length() - 1;
			
		var subStr = text.substr(0, currentCharID);
		get_node(BodyText).text = subStr;
		await get_tree().create_timer(1.0 / charsPerSecond).timeout;
	get_node(BodyText).text = text;
	get_node("AudioStreamPlayer3D").stop();
	textboxsoundrunning = false;
	
	while Input.is_action_pressed("jump") == false:
		await get_tree().create_timer(1.0 / 60.0).timeout;
	
	
	DialogueArgsUtility.SetNextNodeFromStr(nextNode);



func StreamChoiceBox(args : Array[String]):
	visible = true;
	Selected_Choice = -1;
	get_node(HeaderText).text = "SELECT ONE";
	get_node(BodyText).text = "";
	var outputs = args[4].split(" ");
	
	for i in range(0, 4):
		if args[i] != "":  
			get_node(ChoiceButtons[i]).visible = true;
			get_node(ChoiceButtons[i]).text = args[i];
	get_node(ChoiceButtons[0]).grab_focus();
	
	while Selected_Choice == -1:
		await get_tree().create_timer(1.0 / 60.0).timeout;
	
	DialogueArgsUtility.SetNextNodeFromStr(outputs[Selected_Choice]);
	

func EndDialogue():
	dialogueThread = null;
	IsRunning = false;
	CloseDialogueVars();

var textboxsoundrunning = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if textboxsoundrunning == true:
		if get_node("AudioStreamPlayer3D").playing == false:
			get_node("AudioStreamPlayer3D").pitch_scale = randf_range(0.75, 1.25);
			get_node("AudioStreamPlayer3D").play();


func _on_button_choice_1_pressed() -> void:
	Selected_Choice = 0;


func _on_button_choice_2_pressed() -> void:
	Selected_Choice = 1;


func _on_button_choice_3_pressed() -> void:
	Selected_Choice = 2;


func _on_button_choice_4_pressed() -> void:
	Selected_Choice = 3;
