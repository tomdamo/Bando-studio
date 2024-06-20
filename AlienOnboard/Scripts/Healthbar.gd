extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = %DamageBar
@onready var player = $Player/PlayerCharacterBody3D

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	#if health <= 0:
		#queue_free()

	if health < prev_health:
		timer.start()
	else:
		if damage_bar != null:
			damage_bar.value = health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	if damage_bar != null:
		damage_bar.max_value = health
		damage_bar.value = health


# Called when the node enters the scene tree for the first time.
func _ready():
	damage_bar = %DamageBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	damage_bar.value = health
