class_name SceneVars extends Node3D

@export var MusicForScene = "Techno Dungeon.mp3";
@export var DialogueOnStart : DialogueGrid;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout;
	PlayMusic.PlaySong(MusicForScene);
	if DialogueOnStart != null:
		await get_tree().create_timer(0.1).timeout;
		DialogueHandler.Instance.StartDialogue(DialogueOnStart);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
