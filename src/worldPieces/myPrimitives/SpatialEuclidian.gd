extends Spatial
class_name SpatialEuclidian

signal masterPropertyChanged(nodePath,propertyName,newVal)
signal masterMethodInvoked(nodePath,methodName,args)
signal destruction(nodePath)

func getLoopHeight():
	return get_node("/root/WorldGlobalVariables").loopHeight

func _process(_delta):
	transform[3][1] = get_node("/root/WorldGlobalVariables").modLoopHeight(transform[3][1])
