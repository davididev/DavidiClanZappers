class_name BoilerPlate extends Node3D

@export var playerRoot : NodePath;
@export var characterController : NodePath;
@export var camera : NodePath;



static var StartingPosition : Vector3 = Vector3(0.0, 0.0, 0.0);
var moveSpeed = Vector3(0.0, 0.0, 0.0);
const MOVE_PER_SECOND = 10.0;
const MAX_SPEED = 6.0;
const ROTATE_PER_SECOND = 4.0;

var gravity = 0.0;
var targetAngle : float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameDataHolder.Instance.GetGameData();
	get_node(playerRoot).position = StartingPosition;
	

func set_cc_rotation(moveVec : Vector3, delta : float):
	if moveVec != Vector3.ZERO && DialogueHandler.IsRunning == false:
		targetAngle = rad_to_deg(atan2(moveVec.x, moveVec.z));;
		
	var cc : CharacterBody3D = get_node(characterController);
	var rot = cc.rotation_degrees;
	rot.y = rad_to_deg(lerp_angle(deg_to_rad(rot.y), deg_to_rad(targetAngle), delta * ROTATE_PER_SECOND));
	cc.rotation_degrees = rot;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cc : CharacterBody3D = get_node(characterController);
	var moveVec = Vector3(Input.get_axis("ui_left", "ui_right"), 0.0, Input.get_axis("ui_up", "ui_down"));
	
	if DialogueHandler.IsRunning:
		moveVec = Vector3.ZERO;
	
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
	
	#Increase speed
	if Engine.time_scale > 0.1:  #Not paused
		if Input.is_action_just_pressed("speed"):
			Engine.time_scale = 4.0;
		if Input.is_action_just_released("speed"):
			Engine.time_scale = 1.0;
			
	
	if cc.is_on_floor() && gravity < 0.0:
		gravity = 0.0;
		if Engine.time_scale > 0.1:  #Not paused
			if Input.is_action_just_pressed("jump") && DialogueHandler.IsRunning == false && NPC.NPCsOverlapped.size() == 0:
				SoundFXPlayer.PlaySound("retro/jump_002.ogg", get_tree(), get_node("CharacterBody3D").global_position);
				gravity = 5.0;
		
	#Interact
	if Engine.time_scale > 0.1:  #Not paused
		if Input.is_action_just_pressed("jump") && DialogueHandler.IsRunning == false && NPC.NPCsOverlapped.size() > 0:
			print("Starting dialogue.");
			var closestNPCDistance = 10000.0;
			var closestNPC : NPC = null;
			for indivNPC in NPC.NPCsOverlapped:
				var dist = get_node("CharacterBody3D").global_position.distance_to(indivNPC.global_position);
				print(str("Dist of NPC: ", dist));
				if closestNPCDistance > dist:
					closestNPCDistance = dist;
					closestNPC = indivNPC;
					print(str("Closest distance is now: ", closestNPCDistance));
		
			if closestNPC != null:
				if closestNPC.DialogueOnInteract != null:
					closestNPC.RunEvent();
		
	moveSpeed.y = gravity;
	
	cc.velocity = moveSpeed;
	cc.move_and_slide();
	
	
	
	get_node(camera).position = cc.position + Vector3(0.0, 10.0, 3.0);
	
