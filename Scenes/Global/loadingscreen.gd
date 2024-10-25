class_name LoadingUI extends Node2D

static var SceneToLoad = "";
var resource_name;
var scaleY = 0.001;

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("CanvasLayer/Header").text = str("[center]Loading:\n", );
	resource_name = str("res://Scenes/", SceneToLoad, ".tscn")
	ResourceLoader.load_threaded_request(resource_name);
	get_node("Camera2D/CanvasGroup/RichTextLabel").scale = Vector2(1.0, scaleY);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scaleY = move_toward(scaleY, 1.0, 2.0 * delta);
	get_node("Camera2D/CanvasGroup/RichTextLabel").scale = Vector2(1.0, scaleY);
	var progress = [];
	var status = ResourceLoader.load_threaded_get_status(resource_name, progress);
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		
		var percentage = round(progress[0] * 100.0);
		#get_node("CanvasLayer/PerctangeText").text = str(percentage, "%")
		get_node("Camera2D/CanvasGroup/RichTextLabel").text = str("[center]Loading ", percentage, "%[/center]");
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(resource_name));
