extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO: Take the first Dialogue node and duplicate it according to DialogueGrid.WIDTH / HEIGHT
	var x = 0;
	var y = -1;
	for i in DialogueGrid.HEIGHT:
		x = 0;
		for u in DialogueGrid.WIDTH:
			if x == 0 && y == 0:
				print("First one, don't run");
			else:
				var dup = get_node("DialogueNode").duplicate();
				var vx : Vector2 = Vector2(324.0 * x, 162.0 * y)
				dup.position = vx;
				dup.x = x;
				dup.y = y;
				add_child(dup);
			x += 1;
		y += 1;
			
	pass # Replace with function body.


var cam : Camera2D;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cam == null:
		cam = get_node("Camera2D");
	var moveX = Input.get_axis("ui_left", "ui_right");
	var moveY = Input.get_axis("ui_up", "ui_down");
	var moveRel = Vector2(moveX * 324.0, moveY * 324.0) * delta;
	cam.position = cam.position + moveRel;
