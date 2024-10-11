extends Node3D

@export var playerRoot : NodePath;
@export var characterController : NodePath;
@export var animationPlayer : NodePath;
@export var camera : NodePath;

static var StartingPosition : Vector3 = Vector3(0.0, 0.0, 0.0);
var moveSpeed = Vector3(0.0, 0.0, 0.0);
const MOVE_PER_SECOND = 10.0;
const MAX_SPEED = 6.0;
const ROTATE_PER_SECOND = 4.0;

var gravity = 0.0;

var lastAnimation : StringName = &"";
var attackAnimationTime = -1.0;
var targetAngle : float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node(playerRoot).position = StartingPosition;
	

func set_cc_rotation(moveVec : Vector3, delta : float):
	if moveVec != Vector3.ZERO:
		targetAngle = rad_to_deg(atan2(moveVec.x, moveVec.z));;
		
	var cc : CharacterBody3D = get_node(characterController);
	var rot = cc.rotation_degrees;
	rot.y = rad_to_deg(lerp_angle(deg_to_rad(rot.y), deg_to_rad(targetAngle), delta * ROTATE_PER_SECOND));
	cc.rotation_degrees = rot;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cc : CharacterBody3D = get_node(characterController);
	var moveVec = Vector3(Input.get_axis("move_left", "move_right"), 0.0, Input.get_axis("move_up", "move_down"));
	if moveVec.x == 0.0:
		moveSpeed.x = move_toward(moveSpeed.x, 0.0, MOVE_PER_SECOND * delta);
	else:
		moveSpeed.x = move_toward(moveSpeed.x, MAX_SPEED * moveVec.x, MOVE_PER_SECOND * delta);
	if moveVec.z == 0.0:
		moveSpeed.z = move_toward(moveSpeed.z, 0.0, MOVE_PER_SECOND * delta);
	else:
		moveSpeed.z = move_toward(moveSpeed.z, MAX_SPEED * moveVec.z, MOVE_PER_SECOND * delta);
	
	set_cc_rotation(moveVec, delta);
	
	gravity -= 9.8 * delta;
	if gravity < -50.0:
		gravity = -50.0;
	
	if cc.is_on_floor() && gravity < 0.0:
		gravity = 0.0;
		if Input.is_action_just_pressed("jump"):
			gravity = 5.0;
		
		
	moveSpeed.y = gravity;
	cc.velocity = moveSpeed;
	cc.move_and_slide();
	
	
	
	get_node(camera).position = cc.position + Vector3(0.0, 10.0, 3.0);
	movement_animations();
	single_play_animatuons(delta);

func single_play_animatuons(delta : float):
	if attackAnimationTime < 0.0:  #Playing attack or jump animation, don't play movement animations
		return;
	
	attackAnimationTime -= delta;
	if attackAnimationTime <= 0.0:
		if lastAnimation == &"AvatarAnimationLib/JumpStart":
			lastAnimation = &"AvatarAnimationLib/JumpIdle";
			get_node(animationPlayer).play(lastAnimation);

func movement_animations():
	var xzMove = moveSpeed;
	xzMove.y = 0.0;
	if attackAnimationTime >= 0.0:  #Playing attack or jump animation, don't play movement animations
		return;
	
	if is_equal_approx(gravity, 0.0):
		if lastAnimation == &"AvatarAnimationLib/JumpIdle":
			lastAnimation = &"AvatarAnimationLib/JumpEnd";
			get_node(animationPlayer).play(lastAnimation);
			attackAnimationTime = 0.3333;
		
		if xzMove.length() > 0.1:
			if lastAnimation != &"AvatarAnimationLib/Run":
				lastAnimation = &"AvatarAnimationLib/Run";
				get_node(animationPlayer).play(lastAnimation);
		else:
			if lastAnimation != &"AvatarAnimationLib/Idle":
				lastAnimation = &"AvatarAnimationLib/Idle";
				get_node(animationPlayer).play(lastAnimation);
	else:
		if lastAnimation == &"AvatarAnimationLib/Run" || lastAnimation == &"AvatarAnimationLib/Idle":
			lastAnimation = &"AvatarAnimationLib/JumpStart";
			get_node(animationPlayer).play(lastAnimation);
			attackAnimationTime = 0.3333;
		else:
			lastAnimation = &"AvatarAnimationLib/JumpIdle";
			get_node(animationPlayer).play(lastAnimation);
