extends Node


export var loopHeight = 200.0


func modLoopHeight(x):
	return x - loopHeight * floor(x/loopHeight)



func get_rec_spatial_children(node:Node):
	if node is Spatial:
		var appendedChildren = [node]
		for child in node.get_children():
			for i in get_rec_spatial_children(child):
				appendedChildren.append(i)
		return appendedChildren
 
