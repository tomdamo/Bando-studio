


class_name BTNode:
	var state: BTNodeState
	var parent: Node = null
	var children: Array = []
	var data_context := {}

	func _init():
		state = BTNodeState.FAILURE
#
	#func _init(children: Array):
		#for child in children:
			#_attach(child)

	func _attach(node: Node) -> void:
		node.parent = self
		children.append(node)

	func evaluate() -> BTNodeState:
		return NodeState.FAILURE

	func set_data(key: String, value) -> void:
		data_context[key] = value

	func get_data(key: String):
		var value = null
		if data_context.has(key):
			value = data_context[key]
			return value

		var node = parent
		while node != null:
			value = node.get_data(key)
			if value != null:
				return value
			node = node.parent
		return null

	func clear_data(key: String) -> bool:
		if data_context.has(key):
			data_context.erase(key)
			return true

		var node = parent
		while node != null:
			var cleared = node.clear_data(key)
			if cleared:
				return true
			node = node.parent
		return false
