class_name ArmedLabel extends Label

var isPlayingTime = -1.0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("AnimationPlayer").play("ArmedLabelLibrary/Idle");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isPlayingTime > 0.0:
		isPlayingTime -= delta;
	if isPlayingTime <= 0.0:
		get_node("AnimationPlayer").play("ArmedLabelLibrary/Idle");
	

func AttemptRun(vec : Vector2) -> bool:
	if isPlayingTime > 0.0:  #Already running, don't try again
		return false;
	else:
		get_node("AnimationPlayer").play("ArmedLabelLibrary/Burst");
		isPlayingTime = 1.2;
		self.global_position = vec;
		return true;
