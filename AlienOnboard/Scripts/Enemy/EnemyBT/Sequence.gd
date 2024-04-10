class Sequence(Node):
	func _init():
		pass

	func _init(children: Array):
		super._init(children)

	func evaluate() -> NodeState:
		var any_child_is_running = false
		for node in children:
			match node.evaluate():
				NodeState.FAILURE:
					state = NodeState.FAILURE
					return state
				NodeState.SUCCESS:
					continue
				NodeState.RUNNING:
					any_child_is_running = true
					continue
				_:
					state = NodeState.SUCCESS
					return state

		state = any_child_is_running ? NodeState.RUNNING : NodeState.SUCCESS
		return state
