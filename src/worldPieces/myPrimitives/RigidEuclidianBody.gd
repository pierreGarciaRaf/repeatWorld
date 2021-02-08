extends RigidBody

signal masterPropertyChanged(nodePath,propertyName,newVal)
signal masterMethodInvoked(nodePath,methodName,args)



func _integrate_forces(state):
	if state.transform[3][1] > get_node("/root/WorldGlobalVariables").loopHeight or transform[3][1] < 0.0:
		state.transform[3][1] = get_node("/root/WorldGlobalVariables").modLoopHeight(state.transform[3][1])



func _on_Spatial_body_entered(body):
	emit_signal("masterPropertyChanged","angular_velocity",self.angular_velocity)
	emit_signal("masterPropertyChanged","linear_velocity",self.linear_velocity)

