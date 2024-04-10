extends "res://Scripts/AlarmSystem/StateMachine/State.gd"

var _lights_in_range = []
var _range = 10.0
var machine
var node

func _init(machine, node):
	self.machine = machine
	self.node = node

func enter():
	print("Entering StateLevel2")
	get_lights_in_range(_range)

func exit():
	print("Exiting StateLevel2")

func update(delta):
	print("Updating StateLevel2")

func get_lights_in_range(range):
	var player_position = node.global_transform.origin
	var lights = node.get_tree().get_nodes_in_group("lights")

	if lights != null:
		for light in lights:
			var light_position = light.global_transform.origin
			if player_position.distance_to(light_position) <= range:
				_lights_in_range.append(light)
				print(light)
				add_timer_to_light(light)

func add_timer_to_light(light):
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = false
	timer.autostart = true
	light.light_color = Color(1, 0, 0)
	timer.connect("timeout", Callable(light, "_on_Timer_timeout"))
	light.add_child(timer)
	light.set_script(load("res://Scripts/AlarmSystem/LightScript.gd"))

func _on_Timer_timeout():
	node.visible = !node.visible
