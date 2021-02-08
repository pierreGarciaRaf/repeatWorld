extends Spatial

onready var loopHeight = self.get_parent().loopHeight

var childToDuplicatesWithDistanceInt = {}

func childrenHasBaseName(baseName):
	for child in get_children():
		if child.name == baseName:
			return true
	return false


func linkToIntHeight(i):
	var base = null
	if not childrenHasBaseName("base"+str(i)):
		base = Spatial.new()
		base.set_name("base"+str(i))
		add_child(base)
	else:
		base = get_node("base"+str(i))
	for child in $base0.get_children():
		if childToDuplicatesWithDistanceInt.has([child,i]):
			pass
		else:
			if not childToDuplicatesWithDistanceInt.has([child,intsToRepeatOn[0]]):
				child.connect("masterPropertyChanged",self,"masterPropertyChanged")
				child.connect("masterMethodInvoked",self,"masterMethodInvoked")
				child.connect("destruction",self,"destruction")
			var duplicated = (child as Node).duplicate()
			base.add_child(duplicated)
			(duplicated as Node).set_script(load("res://src/worldPieces/myPrimitives/duplicataScript.gd"))
			duplicated.toTrackOnPath = (child as Node).get_path()
			duplicated.intDistance = i
			duplicated.call("_ready")
			if child.is_in_group("principalPlayer"):
				child._setCameraCurrent()
			childToDuplicatesWithDistanceInt[[child,i]] = duplicated


func nodePathInBase(nodePath:NodePath,base):
	var newPathString : String = "" + self.get_path()
	newPathString += "/" + base.name
	for nameIndex in range(self.get_path().get_name_count()+1, nodePath.get_name_count()):
		newPathString += "/" + nodePath.get_name(nameIndex)
	return NodePath(newPathString)

func masterPropertyChanged(nodePath,propertyName,value):
	for base in get_children():
		nodePath = nodePathInBase(nodePath,base)
		get_node(nodePath).set(propertyName,value)

func masterMethodInvoked(nodePath,methodName,args):
	if args == null:
		for base in get_children():
			nodePath = nodePathInBase(nodePath,base)
			get_node(nodePath).call(methodName)
	else:
		for base in get_children():
			nodePath = nodePathInBase(nodePath,base)
			get_node(nodePath).call(methodName,args)

func destruction(nodePath : String):
	nodePath = nodePath.replace("@","")
	for base in get_children():
		nodePath = nodePathInBase(nodePath,base)
		get_node(nodePath).queue_free()

var intsToRepeatOn = [1,-1]


func _ready():
	for i in intsToRepeatOn:
		linkToIntHeight(i)

func _process(_delta):
	for i in intsToRepeatOn:
		linkToIntHeight(i)


