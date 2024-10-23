class_name NPC extends Node3D

static var npcList : Dictionary;
@export var actor_name = "Player";
@export var character_controller_path : NodePath;
@export var DialogueOnInteract : DialogueGrid;
var cc : CharacterBody3D;

static var NPCsOverlapped : Array[NPC];

var TargetPosition : Vector3;
var CurrentTargetMode : TargetMode = TargetMode.INACTIVE;
enum TargetMode { INACTIVE, MOVE_IGNORE_Y, MOVE_FLY_Y};


func _enter_tree() -> void:
	npcList[actor_name] = self;

func _process(delta: float) -> void:
	if cc == null:
		cc = get_node(character_controller_path);
		
func TeleportActor(pos : Vector3):
	if cc == null:
		cc = get_node(character_controller_path);
	cc.global_position = pos;


func PlayerEnteredField(node: Node) -> void:
	NPCsOverlapped.append(self);


func PlayerExitedField(node: Node) -> void:
	NPCsOverlapped.erase(self);
