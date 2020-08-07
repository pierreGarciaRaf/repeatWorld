extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera = null
var viewPortTexture = null

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("Viewport/Camera")
	
	viewPortTexture = get_node("Camera")
	camera.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
	(viewPortTexture as TextureRect).texture = camera.get_viewport().get_texture()
	pass # Replace with function body.

func _process(delta):
	(viewPortTexture as TextureRect).texture = camera.get_viewport().get_texture()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
