class_name CycleTextureList extends Resource

@export var Frames : Array[Texture2D];
@export var DelayPerFrame = 0.2;
var frameID = 0;
var currentFrameTimer = 0.0;

func Init():
	frameID = 0;
	currentFrameTimer = 0.0;
	
func GetCurrentTexture(delta : float):
	currentFrameTimer += delta;
	if currentFrameTimer > DelayPerFrame:
		currentFrameTimer -= DelayPerFrame;
		frameID += 1;
		if frameID >= Frames.size():
			frameID = 0;
	
	return Frames[frameID];
