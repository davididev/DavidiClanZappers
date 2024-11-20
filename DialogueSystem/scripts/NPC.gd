class_name NPC extends Node3D

static var npcList : Dictionary;
@export var actor_name = "Player";
@export var character_controller_path : NodePath;
@export var DialogueOnInteract : DialogueGrid;
@export var send_message_path : NodePath;
var cc : CharacterBody3D;
@export var usesCC = true;

signal PreDialogueEvent;

static var NPCsOverlapped : Array[NPC];

var TargetPosition : Vector3;
var CurrentTargetMode : TargetMode = TargetMode.INACTIVE;
enum TargetMode { INACTIVE, MOVE_IGNORE_Y, MOVE_FLY_Y};

func SendSignal(signalName : String):
	get_node(send_message_path).emit_signal(signalName);

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout;
	npcList.get_or_add(actor_name, self);


func _process(delta: float) -> void:
	if usesCC && cc == null:
		cc = get_node(character_controller_path);
		
func TeleportActor(pos : Vector3):
	if cc == null:
		cc = get_node(character_controller_path);
	cc.global_position = pos;

func RunEvent():
	if PreDialogueEvent.is_null() == false:
		PreDialogueEvent.emit();
	DialogueHandler.Instance.StartDialogue(DialogueOnInteract);

func PlayerEnteredField(node: Node) -> void:
	if node.is_in_group("Player"):
		NPCsOverlapped.append(self);


func PlayerExitedField(node: Node) -> void:
	if node.is_in_group("Player"):
		NPCsOverlapped.erase(self);
