class_name CycleTexturesNode extends Node3D

@export var lists : Array[CycleTextureList];
@export var meshPath : NodePath;

func _init() -> void:
	for entry in lists:
		entry.Init();
		
func _process(delta: float) -> void:
	for i in lists.size():
		var tex = lists[i].GetCurrentTexture(delta);
		var mat = get_node(meshPath).get_surface_override_material(i) as StandardMaterial3D;
		mat.albedo_texture = tex;
		get_node(meshPath).set_surface_override_material(i, mat)
