extends SequenceComposite

func tick(actor, blackboard: Blackboard):
	for child in get_children():
		var status = child.tick(actor, blackboard)
		if status != SUCCESS:
			return status
	return SUCCESS
