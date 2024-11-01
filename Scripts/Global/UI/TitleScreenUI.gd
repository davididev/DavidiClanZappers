extends Control
@export var panels : Array[NodePath];

const MAX_GAMES = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetPanel(0);
	
func SetPanel(id : int):
	for i in range(0, panels.size()):
		get_node(panels[i]).visible = id == i;
	
	if id == 0:
		get_node("Panel SelectGame/Prev Button").grab_focus()
	if id == 1:
		get_node("Panel PlayGame/Button Start").grab_focus();
		get_node("Panel PlayGame/Button Continue").visible = GameDataHolder.Instance.FileExists();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_selecter_button_pressed() -> void:
	SetPanel(1);


func _on_button_start_pressed() -> void:
	GameDataHolder.Instance.NewFile();
	NewOrContinueFile();	
	
func NewOrContinueFile():
	LoadingUI.SceneToLoad = GameDataHolder.Instance.data.ScenePath;
	get_tree().change_scene_to_file("res://Scenes/Global/Loading.tscn");	


func _on_button_continue_pressed() -> void:
	GameDataHolder.Instance.LoadFile();
	NewOrContinueFile();	
