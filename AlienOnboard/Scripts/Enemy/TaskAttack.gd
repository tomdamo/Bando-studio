extends ActionLeaf

var _attackTime: float = 1.0;
var _attackCounter: float = 2.0;

func tick(actor, blackboard: Blackboard):
	var overlaps = actor.find_child("VisionArea").get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			var player :String = "Player"
			if player in overlap.name:
				print(self)
				print("defeated")
				return SUCCESS
	return RUNNING