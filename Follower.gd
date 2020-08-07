extends "KinematicEuclidianBody.gd"


export (NodePath) var toFollowPath = null 
onready var explosion =load("res://explosion.tscn")

export var thrust = 5.0
export var directFollow = 2.0

export var armDelay = 0.1

var basicScale = 1.0
var velocity = Vector3.ZERO

var armed = false



func _ready():
	basicScale = self.scale
	$rocket.visible = true
	$armTimer.wait_time = armDelay

func getTransformTranslation(t:Transform):
	return Vector3(t[3][0],t[3][1],t[3][2])

func getClosestEuclidianTransform(firstTransform : Transform, modulusTransform : Transform):
	var length0q = (getTransformTranslation(firstTransform) - getTransformTranslation(modulusTransform)).length()
	var lengthAdd1q = (getTransformTranslation(firstTransform) - getTransformTranslation(modulusTransform) - Vector3.UP * getLoopHeight()).length()
	var lengthSub1q = (getTransformTranslation(firstTransform) - getTransformTranslation(modulusTransform) + Vector3.UP * getLoopHeight()).length()
	
	var closestDistance = min(min(length0q,lengthAdd1q),lengthSub1q)
	
	match closestDistance:
		length0q:
			return modulusTransform
		lengthAdd1q:
			modulusTransform[3][1] += getLoopHeight()
			return modulusTransform
		lengthSub1q:
			modulusTransform[3][1] -= getLoopHeight()
			return modulusTransform
			



func projectPointOnPlane(pointToProject :Vector3, planePoint : Vector3, planeNormalVec : Vector3):
	return pointToProject - (  ( (pointToProject - planePoint).dot(planeNormalVec) ) / planeNormalVec.length_squared()  )*planeNormalVec


func _physics_process(_delta):
	var toFollow = get_node(toFollowPath)
	var baseTransform = toFollow.transform
	var backVector = toFollow.transform.basis.xform(-2*Vector3.FORWARD)
	baseTransform[3][0] += backVector.x
	baseTransform[3][1] += backVector.y
	baseTransform[3][2] += backVector.z
	var toFollowTransform = getClosestEuclidianTransform(self.transform,baseTransform)
	
	
	#Pre-physics calculation
	var velocityPlaneCloserAcc = Vector3.ZERO
	if toFollow.velocity.length()>0:
		var projected_point = projectPointOnPlane(self.translation, getTransformTranslation(toFollowTransform), toFollow.velocity)
		var projected_speed = projectPointOnPlane(self.velocity, Vector3.ZERO, toFollow.velocity)
		velocityPlaneCloserAcc =  getTransformTranslation(toFollowTransform) -projected_point - projected_speed
		
		projected_point = velocityPlaneCloserAcc + self.translation
	var betaFollower = (getTransformTranslation(toFollowTransform) - self.translation)
	var betaFollowerNormSq = betaFollower.length_squared()
	if betaFollowerNormSq < 1:
		betaFollower = betaFollower / betaFollowerNormSq
	var speedEqualizerAcc = toFollow.velocity - self.velocity
	
	#Physics
	var force = (directFollow * betaFollower + (1-1/(1+toFollow.velocity.length_squared()))*speedEqualizerAcc)
	if force.length() > thrust:
		force = force.normalized() * thrust
	velocity = self.move_and_slide(velocity + force)
	
	
	#Rotation (purely cosmetic)
	var targetTransform = self.transform.looking_at(  self.translation + self.velocity + force *5 ,Vector3.UP)
	self.transform = targetTransform
	self.scale = basicScale
	
	
	#explosion management
	if armed and get_slide_count()>0:
		var explosionScene = explosion.instance()
		explosionScene.name += self.name
		explosionScene.transform = self.transform
		get_parent().add_child(explosionScene)
		emit_signal("destruction",self.get_path())







func _on_armTimer_timeout():
	$armTimer.queue_free()
	$armTimer.stop()
	armed = true
	emit_signal("masterPropertyChanged",$rocket/light.get_path(),"material_override",load("res://FollowerArmedLight.tres"))
