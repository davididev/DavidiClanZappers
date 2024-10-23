class_name TalkingNPC extends CharacterBody3D

@export var DialogueOnInteract : DialogueGrid;
@export var NPCPath : NodePath;
@export var UseGravity : bool = true;
var gravity = 0.0;

func _enter_tree() -> void:
	get_node(NPCPath).DialogueOnInteract = DialogueOnInteract;

func _process(delta: float) -> void:
	if UseGravity:
		gravity -= 9.8 * delta;
		if is_on_floor():
			gravity = 0.0;
	else:
		gravity = 0.0;
	
	var movePerSec = Vector3(0.0, gravity, 0.0);
	velocity = movePerSec;
	move_and_slide();
