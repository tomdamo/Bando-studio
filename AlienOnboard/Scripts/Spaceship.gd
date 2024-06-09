extends MeshInstance3D

# Properties
var amplitude = 0.02  # The amplitude of the floating motion
var frequency = 0.5  # The frequency of the floating motion (in Hz)
var time_passed = 0  # Time passed since the start of the floating motion

func _process(delta):
	# Update time passed
	time_passed += delta

	# Calculate vertical displacement using a sine wave
	var displacement = sin(time_passed * frequency * 2 * PI) * amplitude

	# Update mesh position
	var new_position = position
	new_position.y += displacement
	position = new_position

