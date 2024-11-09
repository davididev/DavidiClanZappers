extends RigidBody3D

@export var MOVE_SPEED = 8;
@export var DeathParticle : PackedScene;
@export var TouchDamage = 5;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SetPower(amt : int):
	TouchDamage = amt;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	linear_velocity = basis.z * MOVE_SPEED;


func _on_body_entered(body: Node) -> void:
	if visible == false:
		return;
	if body.has_signal(&"OnDamage"):
		body.emit_signal(&"OnDamage", TouchDamage);
	
	if DeathParticle != null:
		var inst = DeathParticle.instantiate();
		inst.global_position = global_position;
		get_tree().root.add_child(inst);
	
	Node3DPool.SetActive(self, false);
