extends "SpatialEuclidian.gd"



func _ready():
	$Particles.emitting = true


func _on_selfDestruction_timeout():
	emit_signal("destruction",self.get_path())
