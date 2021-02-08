extends SpatialEuclidian

var velocity = Vector3.ZERO

func _ready():
	$Particles.emitting = true

func _process(delta):
	self.translate(velocity * delta)

func _on_selfDestruction_timeout():
	emit_signal("destruction",self.get_path())
