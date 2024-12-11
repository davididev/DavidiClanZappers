class_name SceneVars extends Node3D

@export var MusicForScene = "Techno Dungeon.mp3";
@export var DialogueOnStart : DialogueGrid;
@export var lightRadius : float = -1.0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout;
	PlayMusic.PlaySong(MusicForScene);
	if DialogueOnStart != null:
		await get_tree().create_timer(0.1).timeout;
		DialogueHandler.Instance.StartDialogue(DialogueOnStart);
	if lightRadius >= 0.0:
		var light : PackedScene = load("res://Prefabs/Lamp.tscn");
		var instance = light.instantiate();
		add_child(instance);
		instance.call("SetRadius", lightRadius);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
