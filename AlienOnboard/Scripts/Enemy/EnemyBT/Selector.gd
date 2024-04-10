extends Node

class Selector(BTNode):
	func _init():
		pass

	func _init(children: Array):
		super._init(children)

	func evaluate() -> NodeState:
		for node in children:
			match node.evaluate():
				NodeState.FAILURE:
					continue
				NodeState.SUCCESS:
					state = NodeState.SUCCESS
					return state
				NodeState.RUNNING:
					state = NodeState.RUNNING
					return state
				_:
					continue

		state = NodeState.FAILURE
		return state
