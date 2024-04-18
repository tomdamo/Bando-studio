extends ActionLeaf

var _attackTime: float = 1.0;
var _attackCounter: float = 2.0;
const GAME_OVER_2 = preload("res://Scenes/UI/GameOver2.tscn")
func tick(actor, blackboard: Blackboard):
	var overlaps = actor.find_child("VisionArea").get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			var player :String = "Player"
			if player in overlap.name:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				actor.get_tree().change_scene_to_file("res://Scenes/UI/GameOver2.tscn")
				print("defeated")
				return SUCCESS
	return RUNNING
