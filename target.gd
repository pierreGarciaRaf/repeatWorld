extends "KinematicEuclidianBody.gd"
export var radius = 100.0

var velocity = Vector3.ZERO

func _physics_process(delta):
	var timeDict = OS.get_time();
	var seconds = timeDict.second;
	velocity = self.move_and_slide(radius*(Vector3.LEFT * sin(2*PI*seconds/10) + Vector3.DOWN * cos(2*PI*seconds/10)))
