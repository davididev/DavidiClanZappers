extends Node2D

@export var possibleImages : Array[NodePath];
var x : int = 0;
var y : int = 0;
var hover_empty_node = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SetImage(id : int):
	var i = 0;
	for np : NodePath in possibleImages:
		get_node(np).set_visible(i == id);
		i += 1;

func SetCoord(x1 : int, y1 : int):
	x = x1;
	y = y1;
	get_node("txt_Coord").text = str("(", x, ",", y, ")");
	

func InitNode(ref : DialogueEntry):
	if ref == null:
		SetImage(0);
		return;
	
	#Blue nodes (1) don't have multiple forks, Red nodes do.
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hover_empty_node:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			print("Clicked empty node.  TODO: Add create node.");
			hover_empty_node = false;
	pass


func _on_node_empty_mouse_entered() -> void:
	if get_node("NodeEmpty").visible == true:
		hover_empty_node = true;
		get_node("NodeEmpty").modulate = Color(1.0, 1.0, 1.0, 1.0);


func _on_node_empty_mouse_exited() -> void:
	if get_node("NodeEmpty").visible == true:
		hover_empty_node = false;
		get_node("NodeEmpty").modulate = Color(1.0, 1.0, 1.0, (55.0 / 255.0));
