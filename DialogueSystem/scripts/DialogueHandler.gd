class_name DialogueHandler extends TextureRect

@export var HeaderText : NodePath;
@export var BodyText : NodePath;
@export var FlashImage : NodePath;

static var Instance : DialogueHandler;
var dialogueThread : DialogueGrid;
static var IsRunning = false;

static var CurrentX : int = 0;
static var CurrentY : int = 0;
static var variables : Dictionary;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Instance = self;

static func SetVariable(vname : String, vvalue : float):
	if variables.find_key(vname) == null:  #Hasn't added variable yet
		vvalue = variables.get_or_add(vname, vvalue);
	else:
		variables[vname] = vvalue;

func StartDialogue(runThis : DialogueGrid):
	CurrentX = 0;
	CurrentY = 0;
	IsRunning = true;
	dialogueThread = runThis;
	ObtainDialogue();

#Using CurrentX and CurrentY, get the DialogueEntry node and start up the function
func ObtainDialogue():
	var currentNode : DialogueEntry = dialogueThread.GetEntry(CurrentX, CurrentY);
	if currentNode == null:
		EndDialogue();
	else:
		var command = currentNode.cmd;
		var args = currentNode.GetArguments();
		if command == "str":
			StreamDialogueBox(args);


func StreamDialogueBox(args : Array[String]):
	var charName = args[0];
	var text : String = args[1];
	text = DialogueArgsUtility.FilterRichText(text);
	text = DialogueArgsUtility.FilterDialogueVariables(text);
	var charsPerSecond = DialogueArgsUtility.ConvertStringToFloat(args[2]);
	var soundFXDirectory = args[3];
	var nextNode = args[4];
	
	var currentCharID = 1;
	while currentCharID < text.length():
		var subStr = text.substr(0, currentCharID);
		get_node(BodyText).text = subStr;
		await get_tree().create_timer(charsPerSecond);
		currentCharID += 1;
		if text[currentCharID] == '[':
			currentCharID = text.find("]", currentCharID);
	

func EndDialogue():
	dialogueThread = null;
	IsRunning = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
