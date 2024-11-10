extends Area3D

@export var TouchDamage = 20;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("TeleportToCheckpoint"):		
		body.call("TeleportToCheckpoint");
		body.emit_signal("OnDamage", TouchDamage)
