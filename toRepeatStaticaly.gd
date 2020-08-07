extends Spatial

onready var loopHeight = self.get_parent().loopHeight

func duplicateToIntHeight(i):
	for child in $base.get_children():
		var duplicated = (child as Node).duplicate()
		(duplicated as Spatial).transform[3][1] +=  i * loopHeight
		self.add_child(duplicated)


var intsToRepeatOn = [1,-1]
func _ready():
	for i in intsToRepeatOn:
		duplicateToIntHeight(i)
