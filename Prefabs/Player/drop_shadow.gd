extends Node3D

var lm : int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lm = pow(2.0, 1.0 - 1.0) + pow(2.0, 2.0 - 1.0);  #Scan layer 1 and 2.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var origin = global_position;
	var end = global_position + Vector3(0.0, -1000.0, 0.0);
	var query = PhysicsRayQueryParameters3D.create(origin, end);
	query.collision_mask = lm;
	var result = space_state.intersect_ray(query);
	var end_pos = result.get("position");
	if end_pos != null:
		get_node("Decal").global_position = end_pos;
