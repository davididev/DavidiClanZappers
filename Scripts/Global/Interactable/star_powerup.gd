extends Area3D

enum StarType {HP, Str, Mag, All}
@export var myType = StarType.HP;
@export var particleRef : NodePath;
@export var SwitchID = 0;
var targetColor : Color;
var currentColor = Color.WHITE;
const COLOR_PER_SECOND = 2.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetColor = Color.RED;  #HP and All
	if myType == StarType.Str:
		targetColor = Color.BLUE;
	if myType == StarType.Mag:
		targetColor = Color.GREEN;
	await get_tree().create_timer(0.05).timeout;
	if GameDataHolder.Instance.data.BoolVars[SwitchID] == true:
		queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentColor.r = move_toward(currentColor.r, targetColor.r, COLOR_PER_SECOND * delta);
	currentColor.g = move_toward(currentColor.g, targetColor.g, COLOR_PER_SECOND * delta);
	currentColor.b = move_toward(currentColor.b, targetColor.b, COLOR_PER_SECOND * delta);
	var mat = get_node(particleRef).get_process_material() as ParticleProcessMaterial;
	mat.color = currentColor;
	get_node(particleRef).set_process_material(mat);
	if currentColor == targetColor && myType == StarType.All:
		if targetColor == Color.RED:
			targetColor = Color.BLUE;
			return;
		if targetColor == Color.BLUE:
			targetColor = Color.GREEN;
			return;
		if targetColor == Color.GREEN:
			targetColor = Color.RED;
			return;


func _on_body_entered(body: Node3D) -> void:
	SoundFXPlayer.PlaySound("retro/powerUp_000.ogg", get_tree(), global_position);
	
	if myType == StarType.Str || myType == StarType.All: 
		PopupText.PrintText(str("Str + 1"), get_tree(), Color.BLUE, global_position);
		GameDataHolder.Instance.data.Str += 1;
	if myType == StarType.Mag || myType == StarType.All: 
		PopupText.PrintText(str("Mag + 1"), get_tree(), Color.GREEN, global_position);
		GameDataHolder.Instance.data.Mag += 1;
	if myType == StarType.HP || myType == StarType.All:
		PopupText.PrintText(str("HP + 1"), get_tree(), Color.RED, global_position);
		GameDataHolder.Instance.data.MaxHealth *= 110;
		GameDataHolder.Instance.data.MaxHealth /= 100;
		GameDataHolder.Instance.data.MinHealth = GameDataHolder.Instance.data.MaxHealth;

	PlayerUI.UpdateHUD = true;
	GameDataHolder.Instance.data.BoolVars[SwitchID] = true;
	queue_free();
