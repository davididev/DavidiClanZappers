extends Node3D

@export var overall_lifetime = 5.0;


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is GPUParticles3D:
			child.emitting = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	overall_lifetime -= delta;
	if overall_lifetime < 0.0:
		queue_free();
