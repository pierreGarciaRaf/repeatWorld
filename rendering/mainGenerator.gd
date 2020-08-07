extends Node
onready var vertical_size = get_node("/root/WorldGlobalVariables").loopHeight

const REC_VIEWPORT_REPEAT = 2

func _ready():
	print("hey")
	createViewports(REC_VIEWPORT_REPEAT)
	placeCameras()

onready var RecScreen = preload("recViewport.tscn")
var generatedUpCameras = []
var generatedDownCameras = []

#Generates n viewports on each side (down & up) of the camera
func createViewports(n):
	#first up viewports:
	for i in range(1,n+1):
		var toAdd = RecScreen.instance()
		add_child(toAdd)
		toAdd.get_node("Viewport").transparent_bg = i!=n
		generatedUpCameras.push_front(toAdd.get_node("Viewport/Camera"))
	print(get_children())
	
	for _i in range(1,n+1):
		var toAdd = RecScreen.instance()
		add_child(toAdd)
		toAdd.get_node("Viewport").transparent_bg = true
		generatedDownCameras.push_front(toAdd.get_node("Viewport/Camera"))
	move_child(get_child(0),get_children().size())

func placeCameras():
	var realCamTransform = (get_tree().current_scene.get_node("Init/Viewport").find_node("Camera") as Spatial).global_transform
	var i = 1
	for camera in generatedUpCameras:
		camera.global_transform = realCamTransform
		camera.global_transform[3][1] -= i * vertical_size * 3
		i += 1
	
	i = 1
	for camera in generatedDownCameras:
		camera.global_transform = realCamTransform
		camera.global_transform[3][1] += i * vertical_size * 3 - vertical_size
		i += 1
	



func _process(_delta):
	placeCameras()
