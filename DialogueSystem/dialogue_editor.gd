extends Node2D

var selectedX : int = 0;
var selectedY : int = 0;
var creatingCommand : String = "";
var creatingArgs : Array[String];
var currentFile : DialogueGrid;
var metaArgsSize : int = 0;
var fileName = "default";


func OnNewFilePressed() -> void:
	for x in range(0, DialogueGrid.WIDTH):
		for y in range(0, DialogueGrid.HEIGHT):
			get_node(str("DialogueNode", x, ",", y)).RefreshNode(null);
			
func OnSaveButtonPressed():
	var newRes = currentFile.duplicate();
	ResourceSaver.save(newRes, GetFileDirectory());
	

func StartEditNode(x : int, y : int):
	selectedX = x;
	selectedY = y;
	SetPanel(2);
	var entry = currentFile.GetEntry(x, y);
	SetNewNodeArguments(entry.cmd);
	var args = entry.GetArguments()
	for i in range(0, args.size()):
		get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Text")).text = args[i];
		
func DeleteNode(x : int, y : int):
	currentFile.AddEntryToGrid(x, y, "", creatingArgs);
	get_node(str("DialogueNode", x, ",", y)).RefreshNode(null);

func OnLoadButtonPressed():
	if ResourceLoader.exists(GetFileDirectory()):
		var res = ResourceLoader.load(GetFileDirectory()) as DialogueGrid;
		await get_tree().create_timer(0.05);
		if res != null:
			currentFile = res;
			for x in range(0, DialogueGrid.WIDTH):
				for y in range(0, DialogueGrid.HEIGHT):
					get_node(str("DialogueNode", x, ",", y)).RefreshNode(currentFile.GetEntry(x, y));
				
func OnChangeTextBox():
	fileName = get_node("Camera2D/NodeEditor/ColorRect/PanelSelectFile/FileName").text;
func GetFileDirectory():
	return str("res://DialogueSystem/output/", fileName, ".res");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO: Take the first Dialogue node and duplicate it according to DialogueGrid.WIDTH / HEIGHT
	currentFile = DialogueGrid.new();
	currentFile.Init();
	SetPanel(0);
	get_node("DialogueNode0,0").SetCoord(0, 0);
	var x = -1;
	var y = 0;
	for i in DialogueGrid.HEIGHT:
		x = 0;
		for u in DialogueGrid.WIDTH:
			if x == 0 && y == 0:
				print("First one, don't run");
			else:
				var dup = get_node("DialogueNode0,0").duplicate();
				dup.name = str("DialogueNode", x, ",", y);
				var vx : Vector2 = Vector2(324.0 * x, 162.0 * y)
				dup.position = vx;
				dup.SetCoord(x, y);
				add_child(dup);
			x += 1;
		y += 1;
			
	pass # Replace with function body.


#Function called when you press the add dialogue node button
func AddDialogueNode():
	#Called when you set the arguments and create the node
	SaveDialigueNode();


func CreateNewNode(x : int, y : int):
	selectedX = x;
	selectedY = y;
	get_node("Camera2D/NodeEditor/ColorRect/PanelPickNodeType/Header").text = str("Add command on: (", x, ",", y, ")");
	creatingCommand = "";
	creatingArgs.clear();
	SetPanel(1);


func SetNewNodeArguments(commandName : String):
	SetPanel(2);
	var meta : DialogueNodeMetaData = ObtainDialogueMeta.GetMeta(commandName);
	creatingCommand = meta.command_name;
	metaArgsSize = meta.arguments.size();
	#creatingArgs = meta.arguments;
	for i in range(0, 6):
		if i < meta.arguments.size():
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Label")).visible = true;
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Text")).visible = true;
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Label")).text = meta.arguments[i];
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Text")).text = meta.defaultValues[i];
		else:
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Label")).visible = false;
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Text")).visible = false;
func SetPanel(id : int):
	get_node("Camera2D/NodeEditor/ColorRect/PanelSelectFile").visible = id == 0;
	get_node("Camera2D/NodeEditor/ColorRect/PanelPickNodeType").visible = id == 1;
	get_node("Camera2D/NodeEditor/ColorRect/PanelSetArgs").visible = id == 2;

var cam : Camera2D;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cam == null:
		cam = get_node("Camera2D");
	var moveX = Input.get_axis("ui_left", "ui_right");
	var moveY = Input.get_axis("ui_up", "ui_down");
	if Input.is_key_pressed(KEY_SHIFT):
		moveX *= 2.0;
		moveY *= 2.0;
	var moveRel = Vector2(moveX * 324.0, moveY * 324.0) * delta;
	cam.position = cam.position + moveRel;


func _on_button_dialogue_box_pressed() -> void:
	SetNewNodeArguments("str");


func _on_button_choice_pressed() -> void:
	SetNewNodeArguments("choice");



#Called when we add a new node or edit the node from the add node button
func SaveDialigueNode():
	var first = true;
	creatingArgs.clear();
	for i in range(0, 6):
		if i < metaArgsSize:
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Label")).visible = true;
			get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Text")).visible = true;
			creatingArgs.append(get_node(str("Camera2D/NodeEditor/ColorRect/PanelSetArgs/Arg ", i, " Text")).text);
	var entry : DialogueEntry;
	
	currentFile.AddEntryToGrid(selectedX, selectedY, creatingCommand, creatingArgs);
	get_node(str("DialogueNode", selectedX, ",", selectedY)).RefreshNode(currentFile.GetEntry(selectedX, selectedY));
	SetPanel(0);


func _on_button_if_then_pressed() -> void:
	SetNewNodeArguments("ifthen");


func _on_button_set_var_2_pressed() -> void:
	SetNewNodeArguments("var");


func _on_button_send_signal_pressed() -> void:
	SetNewNodeArguments("msg");


func _on_button_move_actor_pressed() -> void:
	SetNewNodeArguments("move");


func _on_butotn_wait_pressed() -> void:
	SetNewNodeArguments("wait");


func _on_button_flash_pressed() -> void:
	SetNewNodeArguments("flash");


func _on_button_sound_pressed() -> void:
	SetNewNodeArguments("snd"); 
