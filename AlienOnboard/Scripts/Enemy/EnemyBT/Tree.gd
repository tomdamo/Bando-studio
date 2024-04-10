class_name Tree

class Tree(Node):
	var _root: Node = null

	func _ready():
		_root = setup_tree()

	func _process(_delta: float):
		if _root != null:
			_root.evaluate()

	func setup_tree() -> Node:
		return null
