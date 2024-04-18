extends Light3D

func _on_Timer_timeout():
	# Toggle the light's visibility each time the timer times out.
	self.visible = !self.visible

