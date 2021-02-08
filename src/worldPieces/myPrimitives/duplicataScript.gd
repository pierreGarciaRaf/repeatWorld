extends Spatial
var toTrackOnPath:NodePath
var intDistance:int

var yDistance

func _ready():
	yDistance = intDistance * get_node("/root/WorldGlobalVariables").loopHeight
	

func modfiedTransformGetter():
	
	var node = get_node(toTrackOnPath)
	return node.transform

func _process(_delta):
	transform = modfiedTransformGetter()
	transform[3][1] += yDistance

func _physics_process(_delta):
	transform = modfiedTransformGetter()
	transform[3][1] += yDistance

func _integrate_forces(state):
	state.transform = modfiedTransformGetter()
	state.transform[3][1] += yDistance
