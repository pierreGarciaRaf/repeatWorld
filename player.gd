extends "KinematicEuclidianBody.gd"


var velocity = Vector3.ZERO
var forwardMomentum = 1.0

var verticalVelocity = 0.0

var yaw = 0
var pitch = 0


var dampingStrength = 0.001

var mouseSpeed = null
const MOUSE_SENSIVITY = 0.1

var firstRotation


export var maxHealth = 20
var health : float


export var accSpeed = 0.5
export var maxSpeed = 0.3
enum MovementState {
	flying,
	walking
}

var movementState = MovementState.flying

func _ready():
	firstRotation = self.rotation
	print(180*firstRotation/PI)
	health = maxHealth


func _input(event):
	if(event is InputEventMouseMotion):
		if mouseSpeed == null:
			mouseSpeed = event.relative
	elif event is InputEventKey:
		if event.scancode == KEY_A:
			var ball = load("res://ball.tscn").instance()
			get_node("..").add_child(ball)
			print(ball.get_path())
		if event.scancode == 16777217:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton:
		if event.is_pressed():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _setCameraCurrent():
	$Camera.current = true


func _physics_process(delta):
	#physics
	velocity = self.move_and_slide(self.transform.basis.xform(maxSpeed * Vector3(0,0,-forwardMomentum)))
	verticalVelocity = self.move_and_slide(Vector3(0.0,-verticalVelocity,0.0)).dot(Vector3.DOWN)
	velocity += verticalVelocity*Vector3.DOWN
	#flying game mechanics
	
	forwardMomentum = self.transform.basis.xform_inv(velocity).dot(Vector3.FORWARD)/maxSpeed
	var acc = -accSpeed * sin(pitch) - forwardMomentum*forwardMomentum * dampingStrength * delta
	forwardMomentum = max(0, forwardMomentum + acc)
	var verticalAcc = 30 * exp(-forwardMomentum*forwardMomentum)
	verticalVelocity = verticalVelocity + verticalAcc*delta
	verticalVelocity = verticalVelocity / exp(0.001 * forwardMomentum)
	$CanvasLayer/Label.text = "vertVel : " + String(verticalVelocity) + "\nforwMom" + String(forwardMomentum) + "\nvertAcc" + String(verticalAcc)
	$AudioStreamPlayer3D.unit_db = 80*pow(velocity.length()/500,1.5)-40
	
	#aiming, rotating
	if (mouseSpeed != null):
		yaw -= delta * mouseSpeed.x * MOUSE_SENSIVITY
		pitch = max(-PI*0.5,min(PI*0.5,pitch - delta * mouseSpeed.y * MOUSE_SENSIVITY))
		mouseSpeed = null
	self.rotation = firstRotation
	rotation.y += yaw
	rotate_object_local(Vector3(1,0,0),pitch)

