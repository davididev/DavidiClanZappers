class_name PopupText extends Node3D

@export var textLabel : NodePath;
static var ref_instance = preload("res://Prefabs/Preload/popup_text.tscn");

static func PrintText(textToDisplay : String, t : SceneTree, color : Color, pos : Vector3):
	var instance : PopupText = ref_instance.instantiate(); 
	instance.global_position = pos + Vector3(0.0, 2.0, 0.0);
	t.root.add_child(instance);
	
	instance.RunRoutine(textToDisplay, color, t);
	
func RunRoutine(textToDisplay : String, color : Color, t : SceneTree):
	var label : Label3D = get_node(textLabel);
	var step = 1.0 / 20.0;
	label.modulate = color;
	label.text = textToDisplay;
	var alpha1 = 1.0;
	var alpha2 = 1.0;
	while alpha2 > 0.0:
		if is_zero_approx(alpha1):
			alpha2 = move_toward(alpha2, 0.0, 2.0 * step);
			var c = label.outline_modulate;
			c.a = alpha2;
			label.outline_modulate = c;
		else:
			alpha1 = move_toward(alpha1, 0.0, 1.0 * step);
			var c = label.modulate;
			c.a = alpha2;
			label.modulate = c;
		await t.create_timer(step).timeout;
	
	queue_free();
