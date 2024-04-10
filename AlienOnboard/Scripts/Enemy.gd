extends CharacterBody3D

var speed = 2
var accel = 10

var hp = 5
var detectsplayer = false;
var detectionTimerRunning = false


@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var vision: Area3D = $VisionArea3D
@onready var lostThePlayer: Timer = $DetectionTimer


func _ready():
	return

func _physics_process(delta):
	var direction = Vector3()
	nav.target_position = global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed , accel * delta)
	move_and_slide()
	
	if vision:  # Vision is somehow stuck on NULL
		var checkPlayer = vision.get_overlapping_bodies()
		# Further processing...
	
			
func _on_detection_timer_timeout():
	detectsplayer = false
	detectionTimerRunning = false


func _on_vision_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		detectsplayer = true
		print("player detected")
		if detectionTimerRunning:
			lostThePlayer.stop()
			detectionTimerRunning = false


func _on_vision_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		if !detectionTimerRunning:
			detectsplayer = false
			lostThePlayer.start()
			detectionTimerRunning = true
