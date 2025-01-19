class_name NPCAnimator extends Node3D

@export var characterController : NodePath;
@export var animationPlayer : NodePath;
var lastAnimation : StringName = &"";
var attackAnimationTime = -1.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement_animations();
	single_play_animatuons(delta);

func PlayAttackAnim():
	lastAnimation = &"HumanoidAnim/Attack";
	get_node(animationPlayer).play(lastAnimation, -1, 2.0);  #Set speed to 2x, blend to default value
	attackAnimationTime = 0.4;

func PlaySpellAnim():
	lastAnimation = &"HumanoidAnim/CastSpell";
	get_node(animationPlayer).play(lastAnimation, -1, 2.0);  #Set speed to 2x, blend to default value
	attackAnimationTime = 0.4;

func single_play_animatuons(delta : float):
	if attackAnimationTime < 0.0:  #Playing attack or jump animation, don't play movement animations
		return;
	
	attackAnimationTime -= delta;
	if attackAnimationTime <= 0.0:
		if lastAnimation == &"HumanoidAnim/JumpStart":
			lastAnimation = &"HumanoidAnim/JumpIdle";
			get_node(animationPlayer).play(lastAnimation);
		

func movement_animations():
	var cc : CharacterBody3D = get_node(characterController);
	var xzMove = cc.velocity;
	xzMove.y = 0.0;
	if attackAnimationTime > 0.0:  #Playing attack or jump animation, don't play movement animations
		return;
	
	if cc.is_on_floor():
		if lastAnimation == &"HumanoidAnim/JumpIdle":
			lastAnimation = &"HumanoidAnim/JumpEnd";
			get_node(animationPlayer).play(lastAnimation);
			attackAnimationTime = 1.1;
			return;
		
		if xzMove.length() > 0.1:
			if lastAnimation != &"HumanoidAnim/Walk":
				lastAnimation = &"HumanoidAnim/Walk";
				get_node(animationPlayer).play(lastAnimation);
		if xzMove.length() < 0.1:
			if lastAnimation != &"HumanoidAnim/Idle":
				lastAnimation = &"HumanoidAnim/Idle";
				get_node(animationPlayer).play(lastAnimation);
	else:
		if lastAnimation == &"HumanoidAnim/Walk" || lastAnimation == &"HumanoidAnim/Idle":
			lastAnimation = &"HumanoidAnim/JumpStart";
			get_node(animationPlayer).play(lastAnimation);
			attackAnimationTime = 0.47;
		else:
			lastAnimation = &"HumanoidAnim/JumpIdle";
			get_node(animationPlayer).play(lastAnimation);
